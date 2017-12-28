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

/**
 添加图片到指定的相册, albumName为nil时候, 默认保存到 "MobooGif" 的文件夹
 
 @param image           图片
 @param albumName       相册名称
 @param completionBlock 完成回调
 */
+ (void)saveImage:(UIImage *)image
      toAlbumName:(NSString *)albumName
       completion:(void (^)(NSError *error))completionBlock;

+ (void)addNewGifWithData:(NSData *)data
                  toAlbum:(PHAssetCollection *)album
                  onError:(void(^)(NSError *error))onError;

@end
