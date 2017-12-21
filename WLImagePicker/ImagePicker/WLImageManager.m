//
//  WLImageManager.m
//  WLImagePicker
//
//  Created by Lane on 2017/12/18.
//  Copyright © 2017年 Lane. All rights reserved.
//

#import "WLImageManager.h"

@implementation WLImageManager

+ (instancetype)manager {
    static WLImageManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
        manager.cachingImageMananer = [[PHCachingImageManager alloc] init];
    });
    return manager;
}

+ (void)getAssetWithType:(PHAssetMediaType)mediaType
                 subType:(PHAssetMediaSubtype)subType
              completion:(void (^)(NSArray<PHAsset *> *assetArray))completion {
    PHFetchOptions *fetchOptions = [PHFetchOptions new];
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult *fetchResult = [PHAsset fetchAssetsWithMediaType:mediaType options:fetchOptions];
    NSMutableArray *assetMutableArray = [[NSMutableArray alloc] init];
    
    if (fetchResult.count > 0) {
        [fetchResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[PHAsset class]]) {
                PHAsset *asset = (PHAsset *)obj;
                if (asset.mediaType == mediaType) {
                    [assetMutableArray addObject:asset];
                }
            }
        }];
        completion(assetMutableArray);
    } else {
        completion(nil);
    }
}

+ (void)getImageByAsset:(PHAsset *)asset
             targetSize:(CGSize)targetSize
             completion:(void (^)(UIImage *, BOOL))completion {
    if (!asset) {
        completion(nil, NO);
    }
    if (targetSize.width <= 0 || targetSize.height <= 0) {
        completion(nil, NO);
    }
    PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
    imageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeFast;
    imageRequestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    imageRequestOptions.synchronous = YES;
    imageRequestOptions.networkAccessAllowed = YES;
    [[PHCachingImageManager defaultManager] requestImageForAsset:asset
                                                      targetSize:targetSize
                                                     contentMode:PHImageContentModeAspectFill
                                                         options:imageRequestOptions
                                                   resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                       completion(result, [[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
                                                   }];
}

@end
