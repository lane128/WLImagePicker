//
//  UIButton+ActionBlock.h
//  Displayer
//
//  Created by Lane on 2017/9/28.
//  Copyright © 2017年 ShellColr. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MBButtonEventBlock)(void);

@interface UIButton (ActionBlock)

- (void)mb_addTarget:(id)target action:(SEL)action;

- (void)mb_handlerWithBlock:(MBButtonEventBlock)block;

- (void)mb_handlerEvent:(UIControlEvents)event block:(MBButtonEventBlock)block;

+ (UIButton *)buttonWithImageName:(NSString *)imageName;

+ (UIButton *)buttonWithImageName:(NSString *)imageName highlightImageName:(NSString *)highlightImageName;

+ (UIButton *)buttonWithImageName:(NSString *)imageName highlightImageName:(NSString *)highlightImageName disableImageName:(NSString *)disableImageName;

+ (UIButton *)buttonWithImageName:(NSString *)imageName highlightImageName:(NSString *)highlightImageName title:(NSString *)title;

@end
