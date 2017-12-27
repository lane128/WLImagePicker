//
//  WLVIdeoViewCropController.m
//  WLImagePicker
//
//  Created by Lane on 2017/12/27.
//  Copyright © 2017年 Lane. All rights reserved.
//

#import "WLVideoViewCropController.h"
#import <AVKit/AVKit.h>
#import "UIButton+ActionBlock.h"
#import "UIColor+random.h"

NSInteger const NumberOfImages = 7;

@interface WLVideoViewCropController () <UICollectionViewDataSource>

@property (nonatomic, strong) AVPlayerViewController *moviePlayer;
@property (nonatomic, strong) UICollectionView *imageCollectionView;

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *rigthButton;

@end

@implementation WLVideoViewCropController

- (instancetype)initWithVideoURL:(NSURL *)videoURL {
    self = [super init];
    if (self) {
        _videoURL = videoURL;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupViews];
    [self bindEvents];
    [self.moviePlayer.player play];
}

- (void)setupViews {
    [self.view addSubview:self.closeButton];
    [self.view addSubview:self.rigthButton];
    [self.view addSubview:self.moviePlayer.view];
    [self.view addSubview:self.imageCollectionView];
    
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
    
    [self.moviePlayer.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.closeButton.mas_bottom).offset(20);
        make.right.left.equalTo(self.view);
        make.height.mas_equalTo(VERTICAL_SCREEN_WIDTH);
    }];
    
    [self.imageCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moviePlayer.view.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(VERTICAL_SCREEN_WIDTH / NumberOfImages);
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
        
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return NumberOfImages;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"originalCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor randomColor];
    return cell;
}

#pragma mark - Accessors

- (AVPlayerViewController *)moviePlayer {
    if (!_moviePlayer) {
        _moviePlayer = [[AVPlayerViewController alloc] init];
        _moviePlayer.showsPlaybackControls = NO;
        _moviePlayer.player = [AVPlayer playerWithURL:_videoURL];
        _moviePlayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    return _moviePlayer;
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

- (UICollectionView *)imageCollectionView {
    if (!_imageCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        CGFloat height = VERTICAL_SCREEN_WIDTH / NumberOfImages;
        layout.itemSize = CGSizeMake(height, height);
        _imageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_imageCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"originalCell"];
        _imageCollectionView.dataSource = self;
    }
    return _imageCollectionView;
}

@end
