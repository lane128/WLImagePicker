//
//  WLImageManager.h
//  WLImagePicker
//
//  Created by Lane on 2017/12/18.
//  Copyright © 2017年 Lane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface WLImageManager : NSObject

@property (nonatomic, strong) PHCachingImageManager *cachingImageMananer;

+ (instancetype)manager;

+ (void)getAssetWithType:(PHAssetMediaType)mediaType
                 subType:(PHAssetMediaSubtype)subType
              completion:(void (^)(NSArray<PHAsset *> *assetArray))completion;

+ (void)getImageByAsset:(PHAsset *)asset
             targetSize:(CGSize)targetSize
             completion:(void(^)(UIImage *image, BOOL isDegrade))completion;

@end
