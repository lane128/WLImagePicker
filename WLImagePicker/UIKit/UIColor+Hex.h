//
//  UIColor+Hex.h
//  Displayer
//
//  Created by Lane on 2017/9/25.
//  Copyright © 2017年 ShellColr. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGBA_COLOR(R, G, B, A) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:A]
#define RGB_COLOR(R, G, B) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:1.0f]

extern UIColor *mb_colorWithHexString(NSString *str);

extern UIColor *mb_colorWithHexAndAlpha(NSString *str, CGFloat alpha);

@interface UIColor (Hex)

+ (UIColor *)mb_colorWithHexString:(NSString *)color;

//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)mb_colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

- (UIImage *)mb_translateToImage;

@end
