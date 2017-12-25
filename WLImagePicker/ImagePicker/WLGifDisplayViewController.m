//
//  WLGifDisplayViewController.m
//  WLImagePicker
//
//  Created by Lane on 2017/12/23.
//  Copyright © 2017年 Lane. All rights reserved.
//

#import "WLGifDisplayViewController.h"
#import "WLImageManager.h"
#import "UIButton+ActionBlock.h"

@interface WLGifDisplayViewController ()

@property (nonatomic, strong) YYAnimatedImageView *gifImageView;
@property (nonatomic, strong) UIButton *saveButton;

@end

@implementation WLGifDisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.gifImageView];
    [self.view addSubview:self.saveButton];
    
    [self.gifImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(40);
        make.bottom.equalTo(self.view.mas_bottom).offset(-20 - UIVIEW_SAFEAREA_INSET.bottom);
    }];
    
    [self addEvents];
}

- (void)addEvents {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [tap setNumberOfTapsRequired:2];
    [self.view addGestureRecognizer:tap];
    
    WeakObj(self);
    [self.saveButton mb_handlerWithBlock:^{
        StrongObj(self);
        [WLImageManager addNewGifWithData:self.gifData
                                  toAlbum:nil
                                  onError:^(NSError *error) {
                                      if (error) {
                                          NSLog(@"保存失败");
                                      } else {
                                          NSLog(@"保存成功");
                                      }
                                  }];
    }];
}

- (void)tapAction:(UIGestureRecognizer *)tap {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Accessors

- (YYAnimatedImageView *)gifImageView {
    if (!_gifImageView) {
        _gifImageView = [[YYAnimatedImageView alloc] init];
    }
    return _gifImageView;
}

- (UIButton *)saveButton {
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [_saveButton setTintColor:[UIColor mb_colorWithHexString:@"#FFFFFF"]];
        [_saveButton setBackgroundColor:[UIColor mb_colorWithHexString:@"#369EE8"]];
    }
    return _saveButton;
}

- (void)setGifImage:(UIImage *)gifImage {
    _gifImage = gifImage;
    self.gifImageView.image = _gifImage;
}

@end
