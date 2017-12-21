//
//  WLAssetCollectionViewCell.m
//  WLImagePicker
//
//  Created by Lane on 2017/12/19.
//  Copyright © 2017年 Lane. All rights reserved.
//

#import "WLAssetCollectionViewCell.h"

@interface WLAssetCollectionViewCell ()

@end

@implementation WLAssetCollectionViewCell

+ (NSString *)indentifier {
    return NSStringFromClass([self class]);
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    [self.contentView addSubview:self.assetImageView];
    [self.contentView addSubview:self.assetMarkView];
    [self.contentView addSubview:self.timeLabel];
    
    [self.assetImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-40);
        make.height.mas_equalTo(30);
    }];
    
    [self.assetMarkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(15);
        make.right.equalTo(self.contentView).offset(-5);
        make.bottom.equalTo(self.contentView).offset(-5);
    }];
}

#pragma mark - Override

- (void)prepareForReuse {
    self.assetImageView.image = nil;
}

#pragma mark - Accessors

- (UIImageView *)assetImageView {
    if (!_assetImageView) {
        _assetImageView = [UIImageView new];
        _assetImageView.contentMode = UIViewContentModeScaleAspectFill;
        _assetImageView.clipsToBounds = YES;
    }
    return _assetImageView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.textColor = [UIColor mb_colorWithHexString:@"#ffffff"];
        _timeLabel.font = [UIFont systemFontOfSize:14];
    }
    return _timeLabel;
}

- (UIImageView *)assetMarkView {
    if (!_assetMarkView) {
        _assetMarkView = [UIImageView new];
        _assetImageView.contentMode = UIViewContentModeScaleAspectFill;
        _assetImageView.clipsToBounds = YES;
    }
    return _assetMarkView;
}

@end
