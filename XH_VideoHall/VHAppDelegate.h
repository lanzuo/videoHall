
#import <UIKit/UIKit.h>

@interface VHAppDelegate : UIResponder <UIApplicationDelegate>{
    //RootViewCtrl  * RootVCtrl;
    NSDictionary  * ServiceConfig;
  
}



@property (nonatomic,retain) UIWindow               * window;
@property (nonatomic,retain) UINavigationController * navCtrl;
@property (nonatomic,retain) NSDictionary           * serviceConfig;

+(VHAppDelegate *)App;

@end
