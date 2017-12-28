//
//  WLImagePIckerViewController.m
//  WLImagePicker
//
//  Created by Lane on 2017/12/18.
//  Copyright © 2017年 Lane. All rights reserved.
//

#import "WLImagePIckerViewController.h"
#import "UIButton+ActionBlock.h"
#import "WLCollectionViewFlowLayout.h"
#import "UIColor+random.h"
#import "WLImageManager.h"
#import "WLAssetCollectionViewCell.h"
#import "NSGIF.h"
#import <YYImage/YYImage.h>
#import "WLExtractImagesViewController.h"
#import "WLFrameExtractor.h"
#import "WLVideoViewCropController.h"

static NSString *cellIndicator = @"cellIndicator";
static NSInteger cols = 3;

@interface WLImagePIckerViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *rigthButton;

@property (nonatomic, strong) UICollectionView *displayCollectionView;
@property (nonatomic, strong) WLCollectionViewFlowLayout *layout;

@property (nonatomic, copy) NSArray<PHAsset *> *assetArray;

@end

@implementation WLImagePIckerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self bindEvents];
    
    [WLImageManager getAssetWithType:PHAssetMediaTypeVideo
                             subType:PHAssetMediaSubtypeNone
                          completion:^(NSArray<PHAsset *> *assetArray) {
        self.assetArray = assetArray;
        [self.displayCollectionView reloadData];
    }];
}

- (void)setupViews {
    [self.view addSubview:self.closeButton];
    [self.view addSubview:self.rigthButton];
    [self.view addSubview:self.displayCollectionView];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(self.view).offset(UIVIEW_SAFEAREA_INSET.top);
        make.width.height.mas_equalTo(40);
    }];
    
    [self.rigthButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(self.view).offset(UIVIEW_SAFEAREA_INSET.top);
        make.width.height.mas_equalTo(40);
    }];
    
    [self.displayCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.closeButton.mas_bottom).offset(20);
        make.bottom.equalTo(self.view).offset(-UIVIEW_SAFEAREA_INSET.bottom);
    }];
}

- (void)bindEvents {
    WeakObj(self);
    [self.closeButton mb_handlerWithBlock:^{
        StrongObj(self);
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assetArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WLAssetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[WLAssetCollectionViewCell indentifier]
                                                                           forIndexPath:indexPath];
    cell.backgroundColor = [UIColor randomColor];
    PHAsset *asset = self.assetArray[indexPath.item];
    CGFloat width = VERTICAL_SCREEN_WIDTH / 2.0;
    CGFloat height = width;
    [WLImageManager getImageByAsset:asset
                         targetSize:CGSizeMake(width, height)
                         completion:^(UIImage *image, BOOL isDegrade) {
                             if (!isDegrade) {
                                 cell.assetImageView.image = image;
                             }
                         }];
    [cell addLabelInfo];
    if (asset.mediaType == PHAssetMediaTypeVideo) {
        cell.assetMarkView.image = [UIImage imageNamed:@"videoMark"];
        cell.timeLabel.text = [self formatDuration:asset.duration];
    }
    if (asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
        cell.assetMarkView.image = [UIImage imageNamed:@"livePhoto"];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PHAsset *asset = self.assetArray[indexPath.item];
    if (asset.mediaType == PHAssetMediaTypeVideo) {
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.version = PHVideoRequestOptionsVersionOriginal;
        [[PHImageManager defaultManager] requestAVAssetForVideo:asset
                                                        options:options
                                                  resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                                                      AVURLAsset *urlAsset = (AVURLAsset *)asset;
//                                                      WLExtractImagesViewController *extractImageVC = [WLExtractImagesViewController new];
//                                                      extractImageVC.assetURL = urlAsset.URL;
//                                                      [self presentViewController:extractImageVC animated:YES completion:nil];
                                                      WLVideoViewCropController *videoCropVC = [[WLVideoViewCropController alloc] initWithVideoURL:urlAsset.URL];
                                                      [self presentViewController:videoCropVC animated:YES completion:nil];
                                                  }];
    }
}

#pragma mark - Accessors

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:MBImage(@"close") forState:UIControlStateNormal];
    }
    return _closeButton;
}

- (UIButton *)rigthButton {
    if (!_rigthButton) {
        _rigthButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rigthButton setImage:MBImage(@"rightButton") forState:UIControlStateNormal];
    }
    return _rigthButton;
}

- (UICollectionView *)displayCollectionView {
    if (!_displayCollectionView) {
        WLCollectionViewFlowLayout *layout = [[WLCollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 5;
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        CGFloat itemWidth = (self.view.frame.size.width - (cols + 1) * 5) / cols;
        layout.itemSize = CGSizeMake(itemWidth, itemWidth);
        _displayCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _displayCollectionView.backgroundColor = [UIColor whiteColor];
        [_displayCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellIndicator];
        [_displayCollectionView registerClass:[WLAssetCollectionViewCell class]
                   forCellWithReuseIdentifier:[WLAssetCollectionViewCell indentifier]];
        _displayCollectionView.dataSource = self;
        _displayCollectionView.delegate = self;
    }
    return _displayCollectionView;
}

- (NSString *)formatDuration:(NSTimeInterval)timeDuration {
    NSInteger minutes = timeDuration / 60;
    NSInteger seconds = timeDuration  - minutes * 60;
    return [NSString stringWithFormat:@"%02zd:%02zd", minutes, seconds];
}

#pragma mark - Life cycle

- (void)dealloc {
    NSLog(@"dealloc ==> %@", NSStringFromClass([self class]));
}

@end
