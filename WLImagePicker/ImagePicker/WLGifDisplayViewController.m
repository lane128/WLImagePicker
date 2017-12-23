//
//  WLGifDisplayViewController.m
//  WLImagePicker
//
//  Created by Lane on 2017/12/23.
//  Copyright © 2017年 Lane. All rights reserved.
//

#import "WLGifDisplayViewController.h"

@interface WLGifDisplayViewController ()

@end

@implementation WLGifDisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.gifImageView];
    
    [self.gifImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    
    [self addEvents];
}

- (void)addEvents {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
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

@end
