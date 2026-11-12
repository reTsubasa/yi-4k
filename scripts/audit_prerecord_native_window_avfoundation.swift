// Read-only ordinary AVFoundation compressed-sample inspection. No movie writer.
import Foundation
import AVFoundation
import CoreMedia
import CryptoKit
import CoreVideo
import AudioToolbox

func rational(_ value: CMTime) -> [String:Any] {
    return ["value":value.value,"timescale":value.timescale,"flags":value.flags.rawValue,
            "valid":value.isValid,"numeric":value.isNumeric]
}
let args=CommandLine.arguments
if args.count != 3 && args.count != 4 {fatalError("usage: audit.swift input.mp4 output.json")}
let decode=args.count==4 && args[3]=="decode"
let input=URL(fileURLWithPath:args[1])
let asset=AVURLAsset(url:input)
var tracks:[[String:Any]]=[]
for type in [AVMediaType.video,AVMediaType.audio] {
    guard let track=asset.tracks(withMediaType:type).first else {
        var error:NSError?=nil;let status=asset.statusOfValue(forKey:"tracks",error:&error)
        print("MISSING \(type) status=\(status.rawValue) error=\(String(describing:error)) tracks=\(asset.tracks.map{$0.mediaType.rawValue}) playable=\(asset.isPlayable)")
        exit(2)
    }
    let reader=try AVAssetReader(asset:asset)
    let settings:[String:Any]? = !decode ? nil : type == .video ?
        [kCVPixelBufferPixelFormatTypeKey as String:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange] :
        [AVFormatIDKey:kAudioFormatLinearPCM,AVLinearPCMBitDepthKey:16,AVLinearPCMIsFloatKey:false,AVLinearPCMIsBigEndianKey:false,AVLinearPCMIsNonInterleaved:false]
    let output=AVAssetReaderTrackOutput(track:track,outputSettings:settings)
    output.alwaysCopiesSampleData=false
    reader.add(output)
    guard reader.startReading() else {fatalError("reader start: \(String(describing:reader.error))")}
    var packets:[[String:Any]]=[]
    var emptyEvents:[[String:Any]]=[]
    var pcmHash=SHA256();var pcmBytes=0;var decodedAudioFrames=0
    while let group=output.copyNextSampleBuffer() {
        let count=CMSampleBufferGetNumSamples(group)
        if count==0 {
            emptyEvents.append(["pts":rational(CMSampleBufferGetPresentationTimeStamp(group)),"duration":rational(CMSampleBufferGetDuration(group))])
            continue
        }
        if decode {
            if type == .video {
                guard count==1,let image=CMSampleBufferGetImageBuffer(group) else {fatalError("no decoded image")}
                CVPixelBufferLockBaseAddress(image,.readOnly)
                var hash=SHA256()
                let planes=CVPixelBufferGetPlaneCount(image)
                for plane in 0..<planes {
                    let width=CVPixelBufferGetWidthOfPlane(image,plane)
                    let height=CVPixelBufferGetHeightOfPlane(image,plane)
                    let stride=CVPixelBufferGetBytesPerRowOfPlane(image,plane)
                    guard let base=CVPixelBufferGetBaseAddressOfPlane(image,plane) else {fatalError("no image plane")}
                    let rowBytes=plane==0 ? width : width*2
                    for row in 0..<height {hash.update(data:Data(bytes:base.advanced(by:row*stride),count:rowBytes))}
                }
                CVPixelBufferUnlockBaseAddress(image,.readOnly)
                packets.append(["index":packets.count,"sha256":hash.finalize().map{String(format:"%02x",$0)}.joined(),"pts":rational(CMSampleBufferGetPresentationTimeStamp(group)),"duration":rational(CMSampleBufferGetDuration(group))])
            } else {
                guard let block=CMSampleBufferGetDataBuffer(group) else {fatalError("no PCM data")}
                let length=CMBlockBufferGetDataLength(block);var bytes=Data(count:length)
                let status=bytes.withUnsafeMutableBytes {ptr in CMBlockBufferCopyDataBytes(block,atOffset:0,dataLength:length,destination:ptr.baseAddress!)}
                guard status==noErr else {fatalError("PCM copy failed")}
                pcmHash.update(data:bytes);pcmBytes+=length;decodedAudioFrames+=count
            }
            continue
        }
        for sampleIndex in 0..<count {
        var isolated:CMSampleBuffer?=nil
        let copyStatus=CMSampleBufferCopySampleBufferForRange(allocator:kCFAllocatorDefault,sampleBuffer:group,sampleRange:CFRange(location:sampleIndex,length:1),sampleBufferOut:&isolated)
        guard copyStatus==noErr,let sample=isolated else {fatalError("range copy failed")}

        guard let data=CMSampleBufferGetDataBuffer(sample) else {fatalError("no block buffer")}
        let length=CMBlockBufferGetDataLength(data)
        var bytes=Data(count:length)
        let status=bytes.withUnsafeMutableBytes {ptr in CMBlockBufferCopyDataBytes(data,atOffset:0,dataLength:length,destination:ptr.baseAddress!)}
        guard status==noErr else {fatalError("copy bytes failed")}
        packets.append(["index":packets.count,"bytes":length,"sha256":SHA256.hash(data:bytes).map{String(format:"%02x",$0)}.joined(),
            "pts":rational(CMSampleBufferGetPresentationTimeStamp(sample)),
            "dts":rational(CMSampleBufferGetDecodeTimeStamp(sample)),
            "duration":rational(CMSampleBufferGetDuration(sample)),
            "output_pts":rational(CMSampleBufferGetOutputPresentationTimeStamp(sample)),
            "output_dts":rational(CMSampleBufferGetOutputDecodeTimeStamp(sample)),
            "output_duration":rational(CMSampleBufferGetOutputDuration(sample))])
    }
    }
    guard reader.status == .completed else {fatalError("reader status \(reader.status): \(String(describing:reader.error))")}
    tracks.append(["segments":track.segments.map{["empty":$0.isEmpty,"sourceStart":rational($0.timeMapping.source.start),"sourceDuration":rational($0.timeMapping.source.duration),"targetStart":rational($0.timeMapping.target.start),"targetDuration":rational($0.timeMapping.target.duration)]},"type":type.rawValue,"timeRangeStart":rational(track.timeRange.start),
        "timeRangeDuration":rational(track.timeRange.duration),"packets":packets,"emptyEvents":emptyEvents,"decodedAudioFrames":decodedAudioFrames,"pcmBytes":pcmBytes,"pcmSHA256":pcmHash.finalize().map{String(format:"%02x",$0)}.joined()])
}
let result:[String:Any]=["status":"completed","consumer":"AVFoundation AVAssetReaderTrackOutput(outputSettings:nil)",
    "mode":decode ? "decode" : "packets","os":ProcessInfo.processInfo.operatingSystemVersionString,"assetDuration":rational(asset.duration),"tracks":tracks]
try JSONSerialization.data(withJSONObject:result,options:[.prettyPrinted,.sortedKeys]).write(to:URL(fileURLWithPath:args[2]))
print("completed \(tracks.map{($0["packets"] as! [[String:Any]]).count})")
