//
//  StringUtil.m
//  SocketDemo
//
//  Created by Vegan on 12-7-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "StringUtil.h"

@implementation StringUtil
+(NSString *)getString:(char *)str{
    if (!str) {
        return @"";
    }else {
        return [NSString stringWithUTF8String:str];
    }
}
@end
