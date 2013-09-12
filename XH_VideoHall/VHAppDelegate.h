/*
 Copyright (C) 2013 BesTV All rights reserved.
 Author      : wangdan
 Create date : 2013/8/16
 Version     : 1.0
 Description :  
 */

// Modifier      : wangdan
// Modifier Date : 2013/9/10
// Version       : 1.1
// Description   : 

#import <UIKit/UIKit.h>

@interface VHAppDelegate : UIResponder <UIApplicationDelegate>
{
    NSDictionary  * ND_Config;
}



@property (nonatomic,retain) UIWindow               * window;
@property (nonatomic,retain) UINavigationController * navCtrl;
@property (nonatomic,retain) NSDictionary           * appConfig;

+(VHAppDelegate *)App;

@end
