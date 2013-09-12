//
//  Client.h
//  SocketDemo
//
//  Created by Vegan on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Client : NSObject
{
    int _width;
    int _height;
    bool _isUsed;
    NSString *_ipAddress;
}

@property int width;
@property int height;
@property bool isUsed;
@property (retain) NSString *ipAddress;

-(id)initWithWidth:(int)newWidth andHeight:(int)newHeight andIsUsed:(bool)newIsUsed andIpAddress:(NSString*) newIpAddress; 
@end
