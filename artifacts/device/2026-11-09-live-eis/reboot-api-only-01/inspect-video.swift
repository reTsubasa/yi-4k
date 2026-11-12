import Foundation
import AVFoundation
import CoreVideo

let url = URL(fileURLWithPath: CommandLine.arguments[1])
let asset = AVURLAsset(url: url)
guard let track = asset.tracks(withMediaType: .video).first else {
    fatalError("No video track")
}
let reader = try AVAssetReader(asset: asset)
let output = AVAssetReaderTrackOutput(track: track, outputSettings: [
    kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange
])
output.alwaysCopiesSampleData = false
guard reader.canAdd(output) else { fatalError("Cannot add video output") }
reader.add(output)
guard reader.startReading() else { fatalError("Cannot start decoding: \(String(describing: reader.error))") }
var count = 0
var first: Double? = nil
var last: Double? = nil
while reader.status == .reading {
    let gotSample: Bool = autoreleasepool {
        guard let sample = output.copyNextSampleBuffer() else { return false }
        let pts = CMTimeGetSeconds(CMSampleBufferGetPresentationTimeStamp(sample))
        if first == nil { first = pts }
        last = pts
        count += 1
        return true
    }
    if !gotSample { break }
}
let report: [String: Any] = [
    "validator": "macOS AVFoundation / AVAssetReader, decoded pixel buffers",
    "file": url.lastPathComponent,
    "width": track.naturalSize.width,
    "height": track.naturalSize.height,
    "nominal_fps": track.nominalFrameRate,
    "duration_seconds": CMTimeGetSeconds(asset.duration),
    "decoded_video_frames": count,
    "first_video_pts_seconds": first ?? -1,
    "last_video_pts_seconds": last ?? -1,
    "reader_status": reader.status.rawValue,
    "completed": reader.status == .completed,
    "error": reader.error?.localizedDescription ?? ""
]
let data = try JSONSerialization.data(withJSONObject: report, options: [.prettyPrinted, .sortedKeys])
print(String(data: data, encoding: .utf8)!)
if reader.status != .completed { exit(1) }
