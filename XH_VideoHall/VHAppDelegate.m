
#import "VHAppDelegate.h"
#import "RootViewCtrl.h"

@implementation VHAppDelegate

@synthesize window;

@synthesize serviceConfig = ServiceConfig;

+(VHAppDelegate *)App
{
    return  (VHAppDelegate *)[[UIApplication sharedApplication]delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [application setStatusBarHidden:YES];

    ServiceConfig = [[NSDictionary alloc]initWithObjectsAndKeys:
    @"http://tvepg.bbtv.cn/tv/OttService/QueryPosition?Code=POSITION_BESTV_ONLINE_1",  @"ConfigVideoListAddress",
                                @"http://tvepg.bbtv.cn/tv/OttService/SearchPrograms",  @"ConfigSearchPostAddress",
                                                             @"http://tvpic.bbtv.cn",  @"ConfigImgAddress",
                                   @"http://tvepg.bbtv.cn/tv/OttService/QueryDetail",  @"ConfigVideoDetailAddress",
                                                                                       nil];
    
    //checkNetWork
    NSURL * url = [NSURL URLWithString:@"http://www.baidu.com"];
    NSURLRequest * request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    NSHTTPURLResponse * response;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    if (response == nil) {
        NSLog(@"没有网络");
    }else{
        NSLog(@"网络正常");
        RootViewCtrl  * RootVCtrl = [[RootViewCtrl alloc]init];
        UINavigationController * navCtrl = [[UINavigationController alloc]initWithRootViewController:RootVCtrl];
        self.navCtrl.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.window addSubview:navCtrl.view];
        self.window.rootViewController = navCtrl;
        [self.window makeKeyAndVisible];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



































@end
