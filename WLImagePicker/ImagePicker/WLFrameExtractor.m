//
//  WLFrameExtractor.m
//  WLImagePicker
//
//  Created by Lane on 2017/12/26.
//  Copyright © 2017年 Lane. All rights reserved.
//

#import "WLFrameExtractor.h"

@implementation WLFrameExtractor

+ (void)extractVideoWithURL:(NSURL *)videoURL completion:(void (^)(NSArray<UIImage *> *imagesArray))completion {
    AVURLAsset *videoAsset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    CMTime videoCMTime = videoAsset.duration;
    NSTimeInterval seconds = videoCMTime.value / videoCMTime.timescale;
    
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:videoAsset];
    generator.appliesPreferredTrackTransform = YES;
    generator.maximumSize = CGSizeMake(400, 400);
    generator.requestedTimeToleranceAfter = kCMTimeZero;
    generator.requestedTimeToleranceBefore = kCMTimeZero;
    
    NSMutableArray *timesForExtract = [NSMutableArray array];
    
    for (CGFloat i = 0; i < seconds; i=i+ExtractInterval) {
        CMTime time = CMTimeMake((int64_t)(i * videoCMTime.timescale), videoCMTime.timescale);
        NSValue *timeValue = [NSValue valueWithCMTime:time];
        [timesForExtract addObject:timeValue];
    }
    
    __block NSMutableArray<UIImage *> *imageArray = [NSMutableArray array];
    
    NSInteger handlerTimes = timesForExtract.count;
    __block int callbackCount = 0;
    
    NSLog(@"timesForExtract : %@", timesForExtract);
    
    [generator generateCGImagesAsynchronouslyForTimes:timesForExtract
                                    completionHandler:^(CMTime requestedTime,
                                                        CGImageRef  _Nullable image,
                                                        CMTime actualTime,
                                                        AVAssetImageGeneratorResult result,
                                                        NSError * _Nullable error) {
                                        callbackCount++;
                                        if (!error) {
                                            UIImage *tmpImage = [UIImage imageWithCGImage:image];
                                            NSLog(@"===>request image | %lld - %d", requestedTime.value, requestedTime.timescale);
                                            NSLog(@"===> actual image | %lld - %d", actualTime.value, actualTime.timescale);
                                            [imageArray addObject:tmpImage];
                                        }
                                        if (callbackCount == handlerTimes) {
                                            completion(imageArray);
                                        }
                                    }];
}

+ (void)extractVideoWithURL:(NSURL *)videoURL
                      times:(NSArray<NSValue *> *)times
                       size:(CGSize)size
                 completion:(void (^)(NSArray<UIImage *> *))completion {
    AVURLAsset *videoAsset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:videoAsset];
    generator.appliesPreferredTrackTransform = YES;
    generator.maximumSize = size;
    generator.requestedTimeToleranceAfter = kCMTimeZero;
    generator.requestedTimeToleranceBefore = kCMTimeZero;
    
    __block NSMutableArray<UIImage *> *imageArray = [NSMutableArray array];
    
    NSInteger handlerTimes = times.count;
    __block int callbackCount = 0;
    
    [generator generateCGImagesAsynchronouslyForTimes:times
                                    completionHandler:^(CMTime requestedTime,
                                                        CGImageRef  _Nullable image,
                                                        CMTime actualTime,
                                                        AVAssetImageGeneratorResult result,
                                                        NSError * _Nullable error) {
                                        callbackCount++;
                                        if (!error) {
                                            UIImage *tmpImage = [UIImage imageWithCGImage:image];
                                            NSLog(@"===> actual image | %lld - %d", actualTime.value, actualTime.timescale);
                                            [imageArray addObject:tmpImage];
                                        }
                                        if (callbackCount == handlerTimes) {
                                            completion(imageArray);
                                        }
                                    }];
}

+ (void)extractFrameWithURL:(NSURL *)assetURL completion:(void (^)(NSArray<UIImage *> *))completion {
    AVURLAsset *movie = [AVURLAsset URLAssetWithURL:assetURL options:nil];
    
    NSArray *tracks = [movie tracksWithMediaType:AVMediaTypeVideo];
    AVAssetTrack *track = [tracks firstObject];
    
    NSError *error = nil;
    AVAssetReader *areader = [[AVAssetReader alloc] initWithAsset:movie error:&error];
//    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
//                             [NSNumber numberWithInt:kCVPixelFormatType_32ARGB], kCVPixelBufferPixelFormatTypeKey,
//                             nil];
    
    AVAssetReaderTrackOutput *rout = [[AVAssetReaderTrackOutput alloc] initWithTrack:track
                                                                      outputSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA]
                                                                                                                                      forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
//    rout.alwaysCopiesSampleData = NO;
    [areader addOutput:rout];
    
    [areader startReading];
    
    NSMutableArray<UIImage *> *extractImageArray = [NSMutableArray array];
    
    while ([areader status] == AVAssetReaderStatusReading) {
        CMSampleBufferRef sbuff = [rout copyNextSampleBuffer];
        if (sbuff) {
            UIImage *image = [self imageFromSampleBuffer:sbuff];
            if (image) {
                [extractImageArray addObject:image];
            }
            CFRelease(sbuff);
        }
    }
    
    completion(extractImageArray);
}

+ (UIImage *)imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    // 为媒体数据设置一个CMSampleBuffer的Core Video图像缓存对象
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // 锁定pixel buffer的基地址
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // 得到pixel buffer的基地址
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // 得到pixel buffer的行字节数
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // 得到pixel buffer的宽和高
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    size_t maxValue = MAX(width, height);
    CGFloat rate = (CGFloat)maxValue / 400;
    
//    width = width * rate;
//    height = height * rate;
    
    NSLog(@">>>");
    
    // 创建一个依赖于设备的RGB颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // 用抽样缓存的数据创建一个位图格式的图形上下文（graphics context）对象
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    // 根据这个位图context中的像素数据创建一个Quartz image对象
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // 解锁pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // 释放context和颜色空间
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // 用Quartz image创建一个UIImage对象image
    UIImage *image = [UIImage imageWithCGImage:quartzImage scale:rate orientation:UIImageOrientationRight];
    
    // 释放Quartz image对象
    CGImageRelease(quartzImage);
    
    return (image);
}

@end
