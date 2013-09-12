#import "UILaunchView.h"



@implementation UILaunchView

-(id)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {

        
        LaunchImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
        LaunchImage.image         = [UIImage imageNamed:@"Default.png"];
        [self addSubview:LaunchImage];

        
        [NSTimer scheduledTimerWithTimeInterval:1.0
                                         target:self
                                       selector:@selector(pushToRootCtrl:)
                                       userInfo:nil
                                        repeats:NO];
        
        
        
        
        

    }
    return  self;

    }

-(void)pushToRootCtrl:(NSTimer *)timer {

    [UIView animateWithDuration:1.25 animations:^{
        CGAffineTransform newTransform = CGAffineTransformMakeScale(1.9, 1.9);
        [LaunchImage setTransform:newTransform];}
                     completion:^(BOOL finished){
                         NSLog(@"LaunchImage frame : %@",NSStringFromCGRect(self.frame));
                         //[self.view addSubview:RootCtrl.view];
                         [UIView animateWithDuration:1.2 animations:^{
                             
                            [LaunchImage setAlpha:0.1];} completion:^(BOOL finished){
                                 [LaunchImage removeFromSuperview];
                                //[RootCtrlScreenShoot removeFromSuperview];
                                //[self.navigationController pushViewController:RootCtrl animated:NO];
                             }];
                         
                         
                         
                     }];
}

@end