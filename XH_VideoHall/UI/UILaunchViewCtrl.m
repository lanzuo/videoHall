#import "UILaunchViewCtrl.h"


@implementation UILaunchViewCtrl

-(void)loadView{

    UIView * view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view     = view;
    self.navigationController.navigationBarHidden = YES;
    
    VC_Root = [[UIRootViewCtrl alloc]init];
    //[VW_Root addSubview:RootCtrl.view];
    //[self.view addSubview:VW_Root];
    //[self.view addSubview:RootCtrl.view];
    
    IV_Launch       = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    IV_Launch.image = [UIImage imageNamed:@"Default.png"];
    [self.view addSubview:IV_Launch];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(pushToRootCtrl:)
                                   userInfo:nil
                                    repeats:NO];
    
    
    
}

-(void)pushToRootCtrl:(NSTimer *)timer
{

    [UIView animateWithDuration:1.25
                     animations:^
                                 {
                                     CGAffineTransform newTransform = CGAffineTransformMakeScale(1.9, 1.9);
                                     [IV_Launch setTransform:newTransform];
                                 }
                     completion:^(BOOL finished)
                                 {
                                     [UIView animateWithDuration:1.2
                                                      animations:^
                                                                 {
                                                                     [IV_Launch setAlpha:0.1];
                                                                 }
                                                      completion:^(BOOL finished)
                                                                 {
                                                                     [IV_Launch removeFromSuperview];
                                //self.navigationController.navigationBarHidden = NO;
                                //[VW_Root removeFromSuperview];
                                
                                
                                                                     [self.navigationController pushViewController:VC_Root
                                                                                                          animated:NO];
                                
                               
                                                                  }];
                         
                         
                         
                                 }];
}

@end