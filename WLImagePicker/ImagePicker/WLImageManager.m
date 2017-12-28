//
//  WLImageManager.m
//  WLImagePicker
//
//  Created by Lane on 2017/12/18.
//  Copyright © 2017年 Lane. All rights reserved.
//

#import "WLImageManager.h"
#import "NSString+WLFoundation.h"

NSString * const MobooGif = @"MobooGif";

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

+ (void)saveImage:(UIImage *)image
      toAlbumName:(NSString *)albumName
       completion:(void (^)(NSError *error))completionBlock {
    albumName = [NSString wl_isEmpty:albumName] ? MobooGif : albumName;
    [self makeAlbumWithTitle:albumName
                   onSuccess:^(NSString *albumLocalIdentifier) {
                       PHFetchResult *fetchResult =[PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[albumLocalIdentifier]
                                                                                                        options:nil];
                       PHAssetCollection *targetAssetCollection = [fetchResult firstObject];
                       [self addNewAssetWithImage:image
                                          toAlbum:targetAssetCollection
                                        onSuccess:^(NSString *ImageId) {
                                            completionBlock(nil);
                                        } onError:^(NSError *error) {
                                            completionBlock(error);
                                        }];
                   } onError:^(NSError *error) {
                       completionBlock(error);
                       NSLog(@"create ablum error : %@ ", error);
                   }];
}

// 根据指定名字新建相册，如果存在则返回该相册localIdentifier，不存在则生成指定名字的相册并返回localIdentifier.
+ (void)makeAlbumWithTitle:(NSString *)title
                 onSuccess:(void(^)(NSString *albumLocalIdentifier))onSuccess
                   onError:(void(^)(NSError *error)) onError {
    PHAssetCollection *ablumToMake = [self getAlbumWithName:title];
    if (!ablumToMake) {
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            PHAssetCollectionChangeRequest *createAlbumRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title];
            [createAlbumRequest placeholderForCreatedAssetCollection];
        } completionHandler:^(BOOL success, NSError *error) {
            if (error) {
                onError(error);
            } else {
                onSuccess([self getAlbumWithName:title].localIdentifier);
            }
        }];
    } else {
        onSuccess(ablumToMake.localIdentifier);
    }
}

+ (PHAssetCollection *)getAlbumWithName:(NSString *)AlbumName {
    PHFetchResult *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
                                                                               subtype:PHAssetCollectionSubtypeAlbumRegular
                                                                               options:nil];
    if (assetCollections.count == 0) {
        return nil;
    }
    
    __block PHAssetCollection *myAlbum;
    [assetCollections enumerateObjectsUsingBlock:^(PHAssetCollection *album, NSUInteger idx, BOOL *stop) {
        if ([album.localizedTitle isEqualToString:AlbumName]) {
            myAlbum = album;
            *stop = YES;
        }
    }];
    
    if (!myAlbum) {
        return nil;
    }
    return myAlbum;
}

+ (void)addNewAssetWithImage:(UIImage *)image
                     toAlbum:(PHAssetCollection *)album
                   onSuccess:(void(^)(NSString *ImageId))onSuccess
                     onError:(void(^)(NSError *error))onError {
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetChangeRequest *createAssetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        PHAssetCollectionChangeRequest *albumChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:album];
        PHObjectPlaceholder *placeHolder = [createAssetRequest placeholderForCreatedAsset];
        [albumChangeRequest addAssets:@[placeHolder]];
        if (placeHolder) {
            onSuccess(placeHolder.localIdentifier);
        }
    } completionHandler:^(BOOL success, NSError *error) {
        if (error) {
            onError(error);
        }
    }];
}

+ (void)addNewGifWithData:(NSData *)data
                  toAlbum:(PHAssetCollection *)album
                  onError:(void(^)(NSError *error))onError {
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetResourceCreationOptions *options = [[PHAssetResourceCreationOptions alloc] init];
        [[PHAssetCreationRequest creationRequestForAsset] addResourceWithType:PHAssetResourceTypePhoto data:data options:options];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (error) {
            onError(error);
        } else {
            onError(nil);
        }
    }];
}

@end
