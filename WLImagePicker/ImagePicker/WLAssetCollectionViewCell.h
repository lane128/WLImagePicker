//
//  WLAssetCollectionViewCell.h
//  WLImagePicker
//
//  Created by Lane on 2017/12/19.
//  Copyright © 2017年 Lane. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLAssetCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *assetImageView;
@property (nonatomic, strong) UIImageView *assetMarkView;
@property (nonatomic, strong) UILabel *timeLabel;

+ (NSString *)indentifier;

- (void)addLabelInfo;

@end
