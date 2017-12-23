//
//  Macro.h
//  WLImagePicker
//
//  Created by Lane on 2017/12/18.
//  Copyright © 2017年 Lane. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

#define WeakObj(o) __weak typeof(o) o##Weak = o;
#define StrongObj(o) __strong typeof(o) o = o##Weak;

// layout
#define VERTICAL_SCREEN_HEIGHT MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)
#define VERTICAL_SCREEN_WIDTH  MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)

// log
#define MBLogMethod() NSLog(@"%s %d", __func__, __LINE__)
#define MBLogDeallocInfo(self) NSLog(@"%@ dealloc", NSStringFromClass([self class]));
#define MBLogError(error) NSLog(@"%s %d : %@", __func__, __LINE__, error)

// quick methods
#define MBFont(size) ([UIFont systemFontOfSize:size])
#define MBImage(name) ([UIImage imageNamed:name])

#ifndef is4InchDisplay
#define isScreenMatchesSize(__size__) CGSizeEqualToSize(__size__, [[UIScreen mainScreen] currentMode].size)
#define is3p5InchDisplay (isScreenMatchesSize(CGSizeMake(640, 960)) || isScreenMatchesSize(CGSizeMake(960, 640)))
#define is4InchDisplay (isScreenMatchesSize(CGSizeMake(640, 1136)) || isScreenMatchesSize(CGSizeMake(1136, 640)))
#define is4p7InchDisplay (isScreenMatchesSize(CGSizeMake(750, 1334)) || isScreenMatchesSize(CGSizeMake(1334, 750)))
#define is5p5InchDisplay (isScreenMatchesSize(CGSizeMake(1242, 2208)) || isScreenMatchesSize(CGSizeMake(2208, 1242)) ||\
isScreenMatchesSize(CGSizeMake(1125, 2001)) || isScreenMatchesSize(CGSizeMake(2001, 1125)))

#define isRetina ([[UIScreen mainScreen] scale] > 1)
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define isPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define DEVICE_FULL_SIZE_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define DEVICE_FULL_SIZE_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define NAVIGATED_VIEW_HEIGHT (DEVICE_FULL_SIZE_HEIGHT - DEFAULT_NAVIGATED_VIEW_TOP_INSET)
#define DEFAULT_NAVIGATED_VIEW_RECT CGRectMake(0, 0, DEVICE_FULL_SIZE_WIDTH, NAVIGATED_VIEW_HEIGHT)
#define DEFAULT_FULL_SIZE_VIEW_RECT CGRectMake(0, 0, DEVICE_FULL_SIZE_WIDTH, DEVICE_FULL_SIZE_HEIGHT)
#define DEFAULT_INDENTATION (isPad ? 48. : (is5p5InchDisplay ? 20. : 15.))
#define DEFAULT_INDENTATION_SHORT 10.
#define DEFAULT_CELL_CONTENT_WIDTH (DEVICE_FULL_SIZE_WIDTH - DEFAULT_INDENTATION * 2)
#define DEFAULT_ROW_HEIGHT 44.
#define DAY_SECONDS 86400
#define FLEXIBLE_WIDTH_HEIGHT  (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)
#endif

// system version
#define mb_systemVersionLessThan(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define mb_systemVersionGreaterThan(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)

/// 导航栏 标题,左右按钮一栏默认高度
#define NAVIGATED_VIEW_CONTENT_HEIGHT_DEFAULT 44
/**
 * 动态获取当前"需要"的导航栏的高度(包括了状态栏),
 * 在非iPhoneX上是64, iPhoneX上是88,
 * 在做自定义的导航栏的时候可以用它决定需要有多高
 */
#define NAVIGATED_VIEW_HEIGHT_DYNAMIC (NAVIGATED_VIEW_CONTENT_HEIGHT_DEFAULT + UIApplication.sharedApplication.statusBarFrame.size.height)

#define DEFAULT_NAVIGATED_VIEW_TOP_INSET NAVIGATED_VIEW_HEIGHT_DYNAMIC

/**
 * 在iPhoneX上屏幕之外的inset{44, 0, 34, 0}
 */
#define UIVIEW_SAFEAREA_INSET \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wpartial-availability\"") \
([UIDevice currentDevice].systemVersion.floatValue >= 11.0 \
? (UIApplication.sharedApplication.keyWindow.safeAreaInsets) \
: UIEdgeInsetsZero) \
_Pragma("clang diagnostic pop")

#define FLOAT_EQUAL(__f1, __f2) (fabs((__f1) - (__f2)) < 0.001)
#define IS_IPHONEX (!FLOAT_EQUAL(UIVIEW_SAFEAREA_INSET.top, 0))

#define StatusBar_Height UIApplication.sharedApplication.statusBarFrame.size.height
#define TextFieldTitleFont ([UIFont systemFontOfSize:15])
#define TextFieldFont ([UIFont systemFontOfSize:15])
#define ButtonFont ([UIFont systemFontOfSize:15])
#define NavTitleFont [UIFont boldSystemFontOfSize:15]
#define PwdMinLength 6
#define PwdMaxLength 20
#define CodeLenth 4

#define ExtractInterval 0.1

#endif /* Macro_h */
