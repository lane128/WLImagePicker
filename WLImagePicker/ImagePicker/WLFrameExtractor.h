//
//  WLFrameExtractor.h
//  WLImagePicker
//
//  Created by Lane on 2017/12/26.
//  Copyright © 2017年 Lane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface WLFrameExtractor : NSObject


// AVAssetImageGenerator
+ (void)extractVideoWithURL:(NSURL *)videoURL completion:(void (^)(NSArray<UIImage *> *imagesArray))completion;

// AVAssetTrack
+ (void)extractFrameWithURL:(NSURL *)assetURL completion:(void (^)(NSArray<UIImage *> *imagesArray))completion;

@end
