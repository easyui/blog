开始做的是一般的vod视频截屏，用AVAssetImageGenerator对象就可以实现，而且可以截取任意时间点的视频图像：
```
 open func generateThumbnails(times: [TimeInterval],maximumSize: CGSize, completionHandler: @escaping (([EZPlayerThumbnail]) -> Swift.Void )){  
        guard let imageGenerator = self.imageGenerator else {  
            return;  
        }  
          
        var values = [NSValue]()  
        for time in times {  
            values.append(NSValue(time: CMTimeMakeWithSeconds(time,CMTimeScale(NSEC_PER_SEC))))  
        }  
          
        var thumbnailCount = values.count  
        var thumbnails = [EZPlayerThumbnail]()  
        imageGenerator.cancelAllCGImageGeneration()  
        imageGenerator.appliesPreferredTrackTransform = true  
        imageGenerator.maximumSize = maximumSize  
        imageGenerator.generateCGImagesAsynchronously(forTimes:values) { (requestedTime: CMTime,image: CGImage?,actualTime: CMTime,result: AVAssetImageGeneratorResult,error: Error?) in  
              
            let thumbnail = EZPlayerThumbnail(requestedTime: requestedTime, image: image == nil ? nil :  UIImage(cgImage: image!) , actualTime: actualTime, result: result, error: error)  
            thumbnails.append(thumbnail)  
            thumbnailCount -= 1  
            if thumbnailCount == 0 {  
                DispatchQueue.main.async {  
                    completionHandler(thumbnails)  
                    NotificationCenter.default.post(name: .EZPlayerThumbnailsGenerated, object: self, userInfo: [Notification.Key.EZPlayerThumbnailsKey:thumbnails])  
                }  
                  
            }  
        }  
    }   
```

后来对m3u8截屏发现拿不到流，哦这方法应该对HLS流不行,后来发现AVPlayerItemVideoOutput可以实现,但是只能截取最新的播放的视频图片：
```
  func snapshotImage() -> UIImage? {  
        guard let playerItem = self.playerItem else {  //playerItem is AVPlayerItem  
            return nil  
        }  
          
        if self.videoOutput == nil {  
            self.videoOutput = AVPlayerItemVideoOutput(pixelBufferAttributes: nil)  
            playerItem.remove(self.videoOutput!)  
            playerItem.add(self.videoOutput!)  
        }  
          
        guard let videoOutput = self.videoOutput else {  
            return nil  
        }  
          
        let time = videoOutput.itemTime(forHostTime: CACurrentMediaTime())  
        if videoOutput.hasNewPixelBuffer(forItemTime: time) {  
            let lastSnapshotPixelBuffer = videoOutput.copyPixelBuffer(forItemTime: time, itemTimeForDisplay: nil)  
            if lastSnapshotPixelBuffer != nil {  
                let ciImage = CIImage(cvPixelBuffer: lastSnapshotPixelBuffer!)  
                let context = CIContext(options: nil)  
                let rect = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(CVPixelBufferGetWidth(lastSnapshotPixelBuffer!)), height: CGFloat(CVPixelBufferGetHeight(lastSnapshotPixelBuffer!)))  
                let cgImage = context.createCGImage(ciImage, from: rect)  
                if cgImage != nil {  
                    return UIImage(cgImage: cgImage!)  
                }  
            }  
        }  
        return nil  
    } 
```


[详细代码](https://github.com/easyui/EZPlayer/blob/master/EZPlayer/EZPlayer.swift)

thx:

[使用AVPlayer播放m3u8视频时，实现视频截图](http://blog.csdn.net/hherima/article/details/53576872)

[iOS 小坑记录：如何给 AVPlayer 截图](http://darktechlabs.com/2016/07/15/iOS-%E5%B0%8F%E5%9D%91%E8%AE%B0%E5%BD%95%EF%BC%9A%E5%A6%82%E4%BD%95%E7%BB%99-AVPlayer-%E6%88%AA%E5%9B%BE/)

[iOS获取m3u8流媒体的视频截图](http://www.jianshu.com/p/bd30ce34a76f)

[Real-time Video Processing Using AVPlayerItemVideoOutput](https://developer.apple.com/library/content/samplecode/AVBasicVideoOutput/Introduction/Intro.html)







