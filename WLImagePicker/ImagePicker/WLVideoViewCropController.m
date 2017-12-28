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
#import "WLFrameExtractor.h"
#import "WLAssetCollectionViewCell.h"

NSInteger const NumberOfImages = 7;
CGFloat const DefaultCropTime = 3;

@interface WLVideoViewCropController () <UICollectionViewDataSource>

@property (nonatomic, strong) AVPlayerViewController *moviePlayer;
@property (nonatomic, strong) id timeObserverToken;
@property (nonatomic, strong) UICollectionView *imageCollectionView;
@property (nonatomic, strong) UIView *slideView;
@property (nonatomic, assign) CGPoint endPoint;
@property (nonatomic, assign) NSTimeInterval videoDuration;
@property (nonatomic, strong) NSArray<UIImage *> *imageList;

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *rigthButton;

@end

@implementation WLVideoViewCropController

- (instancetype)initWithVideoURL:(NSURL *)videoURL {
    self = [super init];
    if (self) {
        _videoURL = videoURL;
        _videoDuration = [self videoDuration:videoURL];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupViews];
    [self bindEvents];
    [self extractImages];
    [self.moviePlayer.player seekToTime:CMTimeMake(0, 1) completionHandler:^(BOOL finished) {
        [self.moviePlayer.player play];
    }];
}

- (void)setupViews {
    [self.view addSubview:self.closeButton];
    [self.view addSubview:self.rigthButton];
    [self.view addSubview:self.moviePlayer.view];
    [self.view addSubview:self.imageCollectionView];
    [self.imageCollectionView addSubview:self.slideView];
    
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
    
    [self.slideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.imageCollectionView);
        make.left.equalTo(self.imageCollectionView);
        make.width.mas_equalTo(MAX(DefaultCropTime * VERTICAL_SCREEN_WIDTH / _videoDuration, 20));
        make.height.mas_equalTo(VERTICAL_SCREEN_WIDTH / NumberOfImages);
    }];
    
    [self.imageCollectionView layoutIfNeeded];
    _endPoint = CGPointZero;
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

- (void)extractImages {
    NSTimeInterval seconds = [self videoDuration:self.videoURL];
    NSTimeInterval extractInterval = seconds / NumberOfImages;
    
    NSMutableArray *timesForExtract = [NSMutableArray array];
    
    for (NSInteger i = 0; i < NumberOfImages; i++) {
        CMTime time = CMTimeMake((int64_t)(i * extractInterval), 1);
        NSValue *timeValue = [NSValue valueWithCMTime:time];
        [timesForExtract addObject:timeValue];
    }
    
    [WLFrameExtractor extractVideoWithURL:self.videoURL
                                    times:timesForExtract
                                     size:CGSizeMake(100, 100)
                               completion:^(NSArray<UIImage *> *imagesArray) {
                                   self.imageList = imagesArray;
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       [self.imageCollectionView reloadData];
                                   });
                               }];
}

- (NSTimeInterval)videoDuration:(NSURL *)videoURL {
    AVURLAsset *videoAsset = [[AVURLAsset alloc] initWithURL:self.videoURL options:nil];
    CMTime videoCMTime = videoAsset.duration;
    NSTimeInterval seconds = videoCMTime.value / videoCMTime.timescale;
    return seconds;
}

- (void)panGestureOnSlideView:(UIPanGestureRecognizer *)pan {
    if (pan.state == UIGestureRecognizerStateBegan) {
        [self.moviePlayer.player pause];
    } else if (pan.state == UIGestureRecognizerStateChanged || pan.state == UIGestureRecognizerStateEnded) {
        CGPoint transtion = [pan translationInView:self.imageCollectionView];
        CGFloat minValue = 0;
        CGFloat maxValue = VERTICAL_SCREEN_WIDTH - self.slideView.frame.size.width;
        CGFloat newX = _endPoint.x + transtion.x;
        if (newX < minValue) {
            newX = minValue;
        }
        if (newX > maxValue) {
            newX = maxValue;
        }
        CGRect newFrame = CGRectMake(newX, _endPoint.y, self.slideView.frame.size.width, self.slideView.frame.size.height);
        self.slideView.frame = newFrame;
        CGFloat seedTime = _videoDuration * newX / VERTICAL_SCREEN_WIDTH;
        [self.moviePlayer.player seekToTime:CMTimeMake(seedTime, 1)];
        if (pan.state == UIGestureRecognizerStateEnded) {
            _endPoint = newFrame.origin;
            [self playerDurationWithStartTime:seedTime];
//            [self.moviePlayer.player play];
        }
    }
}

- (void)playerDurationWithStartTime:(CGFloat)seedTime {
    [self.moviePlayer.player seekToTime:CMTimeMake(seedTime, 1)];
    NSValue *endTime = [NSValue valueWithCMTime:CMTimeMake(seedTime + DefaultCropTime, 1)];
    WeakObj(self);
    if (self.timeObserverToken) {
        [self.moviePlayer.player removeTimeObserver:self.timeObserverToken];
    }
    self.timeObserverToken = [self.moviePlayer.player addBoundaryTimeObserverForTimes:@[endTime]
                                                                                queue:dispatch_get_main_queue()
                                                                           usingBlock:^{
                                                                               StrongObj(self);
                                                                               NSLog(@"block fire");
                                                                               [self playerDurationWithStartTime:seedTime];
                                                                           }];
    [self.moviePlayer.player play];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WLAssetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[WLAssetCollectionViewCell indentifier] forIndexPath:indexPath];
    cell.backgroundColor = [UIColor randomColor];
    cell.assetImageView.image = self.imageList[indexPath.item];
    return cell;
}

#pragma mark - Accessors

- (AVPlayerViewController *)moviePlayer {
    if (!_moviePlayer) {
        _moviePlayer = [[AVPlayerViewController alloc] init];
        _moviePlayer.showsPlaybackControls = NO;
        _moviePlayer.player = [AVPlayer playerWithURL:_videoURL];
        _moviePlayer.player.muted = YES;
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
        [_imageCollectionView registerClass:[WLAssetCollectionViewCell class] forCellWithReuseIdentifier:[WLAssetCollectionViewCell indentifier]];
        _imageCollectionView.dataSource = self;
    }
    return _imageCollectionView;
}

- (UIView *)slideView {
    if (!_slideView) {
        _slideView = [[UIView alloc] init];
        _slideView.layer.borderWidth = 2.0;
        _slideView.layer.borderColor = [UIColor mb_colorWithHexString:@"#369EE8"].CGColor;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureOnSlideView:)];
        [_slideView addGestureRecognizer:pan];
    }
    return _slideView;
}

@end
