//
//  ViewController.m
//  WLImagePicker
//
//  Created by Lane on 2017/12/18.
//  Copyright © 2017年 Lane. All rights reserved.
//

#import "ViewController.h"
#import "UIButton+ActionBlock.h"
#import "UIColor+random.h"
#import "WLImagePIckerViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton *pickerButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.pickerButton];
    [self.pickerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    
    WeakObj(self);
    [self.pickerButton mb_handlerWithBlock:^{
        StrongObj(self);
        WLImagePIckerViewController *newVC = [WLImagePIckerViewController new];
        newVC.view.backgroundColor = [UIColor whiteColor];
        [self presentViewController:newVC animated:YES completion:nil];
    }];
}

- (UIButton *)pickerButton {
    if (!_pickerButton) {
        _pickerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pickerButton setTitle:@"Picker" forState:UIControlStateNormal];
        [_pickerButton setTintColor:[UIColor mb_colorWithHexString:@"#FFFFFF"]];
        _pickerButton.backgroundColor = [UIColor mb_colorWithHexString:@"#5CC9F5"];
    }
    return _pickerButton;
}

@end
