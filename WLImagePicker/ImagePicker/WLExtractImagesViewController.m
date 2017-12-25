//
//  WLExtractImagesViewController.m
//  WLImagePicker
//
//  Created by Lane on 2017/12/22.
//  Copyright © 2017年 Lane. All rights reserved.
//

#import "WLExtractImagesViewController.h"
#import "WLCollectionViewFlowLayout.h"
#import "WLAssetCollectionViewCell.h"
#import "UIButton+ActionBlock.h"
#import <YYImage/YYImage.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIImage+GIF.h>
#import "WLGifDisplayViewController.h"

static NSInteger cols = 4;

@interface WLExtractImagesViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *rigthButton;

@end

@implementation WLExtractImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupViews];
    [self bindEvents];
}

- (void)setupViews {
    [self.view addSubview:self.closeButton];
    [self.view addSubview:self.rigthButton];
    [self.view addSubview:self.collectionView];
    
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
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
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
    
    [self.rigthButton mb_handlerWithBlock:^{
        StrongObj(self);
        [self makeGIFFromImages:self.extractImageArray];
    }];
}

- (void)makeGIFFromImages:(NSArray<UIImage *> *)imageArray {
    YYImageEncoder *GifEndcoder = [[YYImageEncoder alloc] initWithType:YYImageTypeGIF];
    GifEndcoder.loopCount = 0;
    [imageArray enumerateObjectsUsingBlock:^(UIImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat duration = ExtractInterval;
        [GifEndcoder addImage:image duration:duration];
    }];
    
    NSData *GifImageData = [GifEndcoder encode];
    YYImage *GifImage = [YYImage imageWithData:GifImageData];
    
    // output the GIF
//    NSString* docsDir = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] path];
//    NSString* fullPath = [docsDir stringByAppendingPathComponent:@"output-gif.gif"];
//    [[NSFileManager defaultManager] createFileAtPath:fullPath contents:GifImageData attributes:nil];
//    NSLog(@"Saved gif at %@", fullPath);
    
    WLGifDisplayViewController *displayVC = [[WLGifDisplayViewController alloc] init];
    displayVC.gifImage = GifImage;
    displayVC.gifData = GifImageData;
    
    [self presentViewController:displayVC animated:YES completion:nil];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.extractImageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WLAssetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[WLAssetCollectionViewCell indentifier]
                                                                                forIndexPath:indexPath];
    UIImage *extractImage = (UIImage *)[self.extractImageArray objectAtIndex:indexPath.item];
    cell.assetImageView.image = extractImage;
    return cell;
}


#pragma mark - Accessors

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        WLCollectionViewFlowLayout *layout = [[WLCollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 5;
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        CGFloat itemWidth = (self.view.frame.size.width - (cols + 1) * 5) / cols;
        layout.itemSize = CGSizeMake(itemWidth, itemWidth);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[WLAssetCollectionViewCell class]
                   forCellWithReuseIdentifier:[WLAssetCollectionViewCell indentifier]];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}

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

- (void)setExtractImageArray:(NSArray *)extractImageArray {
    _extractImageArray = extractImageArray;
    [self.collectionView reloadData];
}

@end
