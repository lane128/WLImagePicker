//
//  NSString+WLFoundation.h
//  WLImagePicker
//
//  Created by Lane on 2017/12/25.
//  Copyright © 2017年 Lane. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (WLFoundation)

+ (BOOL)wl_isEmpty:(NSString *)string;

- (NSString *)wly_trim;

@end
