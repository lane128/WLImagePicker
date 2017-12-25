//
//  NSString+WLFoundation.m
//  WLImagePicker
//
//  Created by Lane on 2017/12/25.
//  Copyright © 2017年 Lane. All rights reserved.
//

#import "NSString+WLFoundation.h"

@implementation NSString (WLFoundation)

+ (BOOL)wl_isEmpty:(NSString *)string {
    if (string == nil) {
        return YES;
    }
    string = [string wly_trim];
    if ([string isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

- (NSString *)wly_trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
