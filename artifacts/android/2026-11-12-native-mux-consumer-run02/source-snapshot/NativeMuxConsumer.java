import android.media.*;
import android.graphics.Rect;
import android.os.Build;
import java.io.*;
import java.nio.*;
import java.security.*;
import org.json.*;

/** Read local MP4 only. No network, app activity, camera, or recording APIs. */
public final class NativeMuxConsumer {
  static String hex(byte[] b) { StringBuilder s=new StringBuilder(); for(byte v:b)s.append(String.format("%02x",v&255));return s.toString(); }
  static String hash(ByteBuffer b) throws Exception { MessageDigest m=MessageDigest.getInstance("SHA-256");m.update(b.duplicate());return hex(m.digest()); }
  static JSONObject format(MediaFormat f) throws Exception {
    JSONObject j=new JSONObject();j.put("literal",f.toString());
    String[] keys={"mime","width","height","durationUs","channel-count","sample-rate","encoder-delay","encoder-padding","color-format","stride","slice-height","crop-left","crop-right","crop-top","crop-bottom","pcm-encoding"};
    for(String k:keys)if(f.containsKey(k))j.put(k,k.equals("mime")?f.getString(k):k.equals("durationUs")?String.valueOf(f.getLong(k)):String.valueOf(f.getInteger(k)));
    return j;
  }
  static int track(MediaExtractor e,boolean video) {
    for(int i=0;i<e.getTrackCount();i++)if(e.getTrackFormat(i).getString("mime").startsWith(video?"video/":"audio/"))return i;
    throw new IllegalStateException("missing requested track");
  }
  static JSONObject extract(String path,boolean video) throws Exception {
    MediaExtractor e=new MediaExtractor();e.setDataSource(path);int st=track(e,video);MediaFormat f=e.getTrackFormat(st);e.selectTrack(st);
    JSONObject j=new JSONObject();j.put("trackIndex",st);j.put("format",format(f));JSONArray packets=new JSONArray();ByteBuffer b=ByteBuffer.allocateDirect(8*1024*1024);
    int i=0;while(true){b.clear();int size=e.readSampleData(b,0);if(size<0)break;b.position(0);b.limit(size);JSONObject p=new JSONObject();
      p.put("index",i++);p.put("bytes",size);p.put("sha256",hash(b));p.put("ptsUs",e.getSampleTime());p.put("flags",e.getSampleFlags());packets.put(p);if(!e.advance())break;}
    j.put("packets",packets);j.put("count",i);j.put("DTSAvailable",false);j.put("packetDurationAvailable",false);e.release();return j;
  }
  static String imageHash(Image image) throws Exception {
    MessageDigest m=MessageDigest.getInstance("SHA-256");Rect c=image.getCropRect();Image.Plane[] planes=image.getPlanes();
    if(planes.length!=3)throw new IllegalStateException("expected three YUV420 planes");
    for(int i=0;i<3;i++){
      int shift=i==0?0:1;int left=c.left>>shift,top=c.top>>shift,w=(c.width()+((1<<shift)-1))>>shift,h=(c.height()+((1<<shift)-1))>>shift;
      ByteBuffer b=planes[i].getBuffer().duplicate();int origin=b.position(),row=planes[i].getRowStride(),pixel=planes[i].getPixelStride();byte[] line=new byte[w];
      for(int y=0;y<h;y++){for(int x=0;x<w;x++)line[x]=b.get(origin+(top+y)*row+(left+x)*pixel);m.update(line);}
    }return hex(m.digest());
  }
  static JSONObject decode(String path,boolean video,int first,int wanted) throws Exception {
    MediaExtractor e=new MediaExtractor();e.setDataSource(path);int st=track(e,video);MediaFormat f=e.getTrackFormat(st);e.selectTrack(st);
    for(int i=0;i<first;i++)if(!e.advance())throw new IllegalStateException("source before selected start");
    MediaCodec c=MediaCodec.createDecoderByType(f.getString("mime"));String codecName=c.getName();
    if(video)f.setInteger(MediaFormat.KEY_COLOR_FORMAT,MediaCodecInfo.CodecCapabilities.COLOR_FormatYUV420Flexible);
    c.configure(f,null,null,0);c.start();JSONObject j=new JSONObject();j.put("codec",codecName);j.put("configuredFormat",format(f));j.put("firstInputIndex",first);j.put("requestedInputs",wanted);
    JSONArray outputs=new JSONArray();JSONArray changes=new JSONArray();int fed=0;boolean inputEOS=false,outputEOS=false;long pcmBytes=0;MessageDigest pcm=MessageDigest.getInstance("SHA-256");int idle=0;
    while(!outputEOS){boolean progress=false;
      if(!inputEOS){int index=c.dequeueInputBuffer(10000);if(index>=0){ByteBuffer b=c.getInputBuffer(index);b.clear();int size=fed>=wanted?-1:e.readSampleData(b,0);
        if(size<0){c.queueInputBuffer(index,0,0,0,MediaCodec.BUFFER_FLAG_END_OF_STREAM);inputEOS=true;}
        else {long pts=e.getSampleTime();c.queueInputBuffer(index,0,size,pts,e.getSampleFlags()&MediaExtractor.SAMPLE_FLAG_SYNC);fed++;e.advance();}progress=true;}}
      MediaCodec.BufferInfo info=new MediaCodec.BufferInfo();int index=c.dequeueOutputBuffer(info,10000);
      if(index==MediaCodec.INFO_OUTPUT_FORMAT_CHANGED){changes.put(format(c.getOutputFormat()));progress=true;}
      else if(index>=0){progress=true;if(info.size>0){JSONObject p=new JSONObject();p.put("index",outputs.length());p.put("ptsUs",info.presentationTimeUs);p.put("bytes",info.size);p.put("flags",info.flags);
        if(video){Image image=c.getOutputImage(index);if(image==null)throw new IllegalStateException("decoder does not expose YUV image");p.put("sha256",imageHash(image));p.put("width",image.getCropRect().width());p.put("height",image.getCropRect().height());image.close();}
        else{ByteBuffer b=c.getOutputBuffer(index).duplicate();b.position(info.offset);b.limit(info.offset+info.size);pcm.update(b.duplicate());p.put("sha256",hash(b));pcmBytes+=info.size;}
        outputs.put(p);}
        outputEOS=(info.flags&MediaCodec.BUFFER_FLAG_END_OF_STREAM)!=0;c.releaseOutputBuffer(index,false);}
      if(progress)idle=0;else if(++idle>1000)throw new IllegalStateException("codec stalled");
    }
    j.put("fedInputs",fed);j.put("outputs",outputs);j.put("outputCount",outputs.length());j.put("outputFormats",changes);j.put("outputEOS",outputEOS);
    if(!video){j.put("pcmBytes",pcmBytes);j.put("pcmSHA256",hex(pcm.digest()));}
    c.stop();c.release();e.release();return j;
  }
  public static void main(String[] args) throws Exception {
    if(args.length!=3)throw new IllegalArgumentException("local MP4, output JSON, source|candidate");String path=args[0],out=args[1];boolean source=args[2].equals("source");
    JSONObject result=new JSONObject();result.put("scope","Android local MediaExtractor / MediaCodec only; no surface playback / camera / network");result.put("sdk",Build.VERSION.SDK_INT);result.put("fingerprint",Build.FINGERPRINT);result.put("path",path);
    try{JSONArray tracks=new JSONArray();for(boolean video:new boolean[]{true,false}){JSONObject j=extract(path,video);j.put("kind",video?"video":"audio");tracks.put(j);}result.put("tracks",tracks);
      JSONArray decoded=new JSONArray();decoded.put(decode(path,true,source?88:0,1831));decoded.put(decode(path,false,source?137:0,2863));result.put("decoded",decoded);result.put("status","completed_platform_reads_and_decodes");}
    catch(Throwable error){result.put("status","failed_platform_reads_or_decode");result.put("error",error.toString());StringWriter s=new StringWriter();error.printStackTrace(new PrintWriter(s));result.put("stack",s.toString());}
    try(FileWriter w=new FileWriter(out)){w.write(result.toString(2));w.write("\n");}
    System.out.println(result.optString("status"));if(result.has("error"))throw new RuntimeException(result.optString("error"));
  }
}
