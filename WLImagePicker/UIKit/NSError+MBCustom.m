//
//  NSError+MBCustom.m
//  MoBoo
//
//  Created by Lane on 2017/11/8.
//  Copyright © 2017年 ShellColr. All rights reserved.
//

NSString * const kMobooResponseErrorDomain = @"com.shellcolr.moboo";

#import "NSError+MBCustom.h"

@implementation NSError (MBCustom)

+ (NSError *)errorWithCode:(NSInteger)code userInfo:(NSDictionary *)userInfo {
    NSError *error = [[NSError alloc] initWithDomain:kMobooResponseErrorDomain code:code userInfo:userInfo];
    return error;
}

@end
