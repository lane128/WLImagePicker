//
//  WLVideoViewCropController.h
//  WLImagePicker
//
//  Created by Lane on 2017/12/27.
//  Copyright © 2017年 Lane. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLVideoViewCropController : UIViewController

@property (nonatomic, strong) NSURL *videoURL;

- (instancetype)initWithVideoURL:(NSURL *)videoURL;

@end
