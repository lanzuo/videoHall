//
//  Client.m
//  SocketDemo
//
//  Created by Vegan on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Client.h"

@implementation Client

@synthesize width=_width;
@synthesize height=_height;
@synthesize isUsed=_isUsed;
@synthesize ipAddress=_ipAddress;


-(id)initWithWidth:(int)newWidth andHeight:(int)newHeight andIsUsed:(bool)newIsUsed andIpAddress:(NSString*) newIpAddress
{
    self = [self init];
    self.width = newWidth;
    self.height = newHeight;
    self.isUsed = newIsUsed;
    self.ipAddress = newIpAddress;
    return self;
}
@end
