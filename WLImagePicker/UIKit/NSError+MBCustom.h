//
//  NSError+MBCustom.h
//  MoBoo
//
//  Created by Lane on 2017/11/8.
//  Copyright © 2017年 ShellColr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (MBCustom)

+ (NSError *)errorWithCode:(NSInteger)code userInfo:(NSDictionary *)userInfo;

@end
