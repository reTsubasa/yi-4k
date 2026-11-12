package dev.yi4k.control;

import android.media.MediaExtractor;
import android.media.MediaFormat;
import android.media.MediaMetadataRetriever;
import android.net.Uri;
import android.test.InstrumentationTestCase;
import androidx.media3.common.MimeTypes;
import androidx.media3.transformer.Composition;
import androidx.media3.transformer.ExportException;
import androidx.media3.transformer.ExportResult;
import androidx.media3.transformer.Transformer;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicReference;

/** Real codec test for a connected Android device. Compilation alone is not execution. */
public final class VideoEditDeviceTest extends InstrumentationTestCase {
    public void testActualClipMuteRotationAndVideoSamples() throws Exception {
        runExportCase(true, true, 90);
    }

    public void testActualClipPreservesAudioAndLandscape() throws Exception {
        runExportCase(false, false, 0);
    }

    private void runExportCase(boolean mute, boolean grayscale, int rotation) throws Exception {
        File source=File.createTempFile("fixture-",".mp4",getInstrumentation().getTargetContext().getCacheDir());
        File output=File.createTempFile("result-",".mp4",source.getParentFile());
        AtomicReference<Transformer> transformer=new AtomicReference<>();
        AtomicReference<Throwable> failure=new AtomicReference<>();
        CountDownLatch complete=new CountDownLatch(1);
        try {
            try(InputStream input=getInstrumentation().getContext().getAssets().open("editor-av-fixture.mp4");
                FileOutputStream file=new FileOutputStream(source)) {
                byte[] buffer=new byte[8192];int n;while((n=input.read(buffer))!=-1)file.write(buffer,0,n);
            }
            getInstrumentation().runOnMainSync(()->{
                try {
                    Transformer job=new Transformer.Builder(getInstrumentation().getTargetContext())
                            .setVideoMimeType(MimeTypes.VIDEO_H264).setAudioMimeType(MimeTypes.AUDIO_AAC)
                            .addListener(new Transformer.Listener(){
                                @Override public void onCompleted(Composition c,ExportResult r){complete.countDown();}
                                @Override public void onError(Composition c,ExportResult r,ExportException e){failure.set(e);complete.countDown();}
                            }).build();
                    transformer.set(job);
                    job.start(VideoEditMedia.edited(Uri.fromFile(source),new VideoEditPlan(3000,500,2500,mute,grayscale,rotation)),output.getAbsolutePath());
                }catch(Exception error){failure.set(error);complete.countDown();}
            });
            assertTrue("Real Android encoder timed out",complete.await(60,TimeUnit.SECONDS));
            if(failure.get()!=null)throw new AssertionError("Android Transformer failed",failure.get());
            assertTrue(output.length()>0);
            try(MediaMetadataRetriever reader=new MediaMetadataRetriever()) {
                reader.setDataSource(output.getAbsolutePath());
                long duration=Long.parseLong(reader.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION));
                assertTrue("Expected a two-second clip, got "+duration,duration>=1850&&duration<=2150);
                android.graphics.Bitmap frame=reader.getFrameAtTime(0);
                assertNotNull("Output must decode a real first frame",frame);
                try {
                    if(grayscale) for(int y=1;y<10;y++) for(int x=1;x<10;x++) {
                        int pixel=frame.getPixel(frame.getWidth()*x/10,frame.getHeight()*y/10);
                        int red=android.graphics.Color.red(pixel),green=android.graphics.Color.green(pixel),blue=android.graphics.Color.blue(pixel);
                        assertTrue("Grayscale output must decode with near-equal RGB channels",
                                Math.max(red,Math.max(green,blue))-Math.min(red,Math.min(green,blue))<=8);
                    }
                } finally { frame.recycle(); }
                int width=Integer.parseInt(reader.extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_WIDTH));
                int height=Integer.parseInt(reader.extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_HEIGHT));
                int angle=Integer.parseInt(reader.extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_ROTATION));
                if(angle==90||angle==270){int swap=width;width=height;height=swap;}
                if(rotation==90||rotation==270)assertTrue("Quarter-turn output should be portrait",height>width);
                else assertTrue("Unrotated output should remain landscape",width>height);
            }
            MediaExtractor extractor=new MediaExtractor();
            try {
                extractor.setDataSource(output.getAbsolutePath());int videos=0,audios=0,videoTrack=-1,audioTrack=-1;
                for(int i=0;i<extractor.getTrackCount();i++){
                    MediaFormat track=extractor.getTrackFormat(i);String mime=track.getString(MediaFormat.KEY_MIME);
                    if(mime!=null&&mime.startsWith("video/")){videos++;videoTrack=i;extractor.selectTrack(i);}
                    if(mime!=null&&mime.startsWith("audio/")){audios++;audioTrack=i;}
                }
                assertEquals(1,videos);assertEquals("Audio track must follow mute setting",mute?0:1,audios);
                int samples=0;while(extractor.getSampleTime()>=0){samples++;if(!extractor.advance())break;}
                assertTrue("Expected real muxed video samples",samples>=25);
                if(!mute){
                    extractor.unselectTrack(videoTrack);extractor.selectTrack(audioTrack);
                    extractor.seekTo(0,MediaExtractor.SEEK_TO_PREVIOUS_SYNC);
                    int audioSamples=0;long previous=-1,last=-1;
                    while(extractor.getSampleTime()>=0){
                        last=extractor.getSampleTime();
                        assertTrue("Audio timestamps must increase",last>previous);
                        previous=last;audioSamples++;
                        if(!extractor.advance())break;
                    }
                    assertTrue("Retained AAC must contain real audio samples",audioSamples>=70);
                    assertTrue("Retained audio should span the clipped two seconds",last>=1800000&&last<=2150000);
                }
            }finally{extractor.release();}
            assertTrue("Original file must remain",source.exists());
        }finally{
            getInstrumentation().runOnMainSync(()->{Transformer job=transformer.get();if(job!=null)job.cancel();});
            source.delete();output.delete();
        }
    }
}
