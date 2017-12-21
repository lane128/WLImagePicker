//
//  UIButton+ActionBlock.m
//  Displayer
//
//  Created by Lane on 2017/9/28.
//  Copyright © 2017年 ShellColr. All rights reserved.
//

#import "UIButton+ActionBlock.h"
#import <objc/runtime.h>

@implementation UIButton (ActionBlock)

static char actionBlockChar;

- (void)mb_addTarget:(id)target action:(SEL)action {
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)mb_handlerWithBlock:(MBButtonEventBlock)block {
    objc_setAssociatedObject(self, &actionBlockChar, block, OBJC_ASSOCIATION_COPY);
    [self addTarget:self action:@selector(actionMethod:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)mb_handlerEvent:(UIControlEvents)event block:(MBButtonEventBlock)block {
    objc_setAssociatedObject(self, &actionBlockChar, block, OBJC_ASSOCIATION_COPY);
    [self addTarget:self action:@selector(actionMethod:) forControlEvents:event];
}

- (void)actionMethod:(UIButton *)button {
    MBButtonEventBlock block = (MBButtonEventBlock)objc_getAssociatedObject(self, &actionBlockChar);
    if (block) {
        block();
    }
}

+ (UIButton *)buttonWithImageName:(NSString *)imageName {
    return [self buttonWithImageName:imageName
                  highlightImageName:imageName];
}

+ (UIButton *)buttonWithImageName:(NSString *)imageName highlightImageName:(NSString *)highlightImageName {
    return [self buttonWithImageName:imageName
                  highlightImageName:highlightImageName
                    disableImageName:imageName];
}

+ (UIButton *)buttonWithImageName:(NSString *)imageName highlightImageName:(NSString *)highlightImageName disableImageName:(NSString *)disableImageName {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highlightImageName] forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:disableImageName] forState:UIControlStateDisabled];
    return button;
}

+ (UIButton *)buttonWithImageName:(NSString *)imageName highlightImageName:(NSString *)highlightImageName title:(NSString *)title {
    UIButton *button = [self buttonWithImageName:imageName highlightImageName:highlightImageName];
    [button setTitle:title forState:UIControlStateNormal];
    return button;
}

@end
