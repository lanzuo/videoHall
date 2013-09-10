#import "NavBar.h"

@implementation NavBar

-(id)initWithFrame:(CGRect)frame{

    if (self == [super initWithFrame:frame]) {
        
        navigationBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
        UINavigationItem *barTitle = [[UINavigationItem alloc] init];
        UILabel * _barTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
        _barTitle.text  = @"节目";
        _barTitle.backgroundColor = [UIColor clearColor];
        _barTitle.textAlignment = UITextAlignmentCenter;
        _barTitle.textColor = [UIColor whiteColor];
        _barTitle.font = [UIFont systemFontOfSize:23];
        [barTitle setTitleView:_barTitle];
        
        UIButton *_menu = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
        [_menu setBackgroundImage:[UIImage imageNamed:@"btn_menu.png"] forState:UIControlStateNormal];
        [_menu addTarget:self action:@selector(btnMenuClick) forControlEvents:UIControlEventTouchDown];
        UIBarButtonItem *btnMenu = [[UIBarButtonItem alloc]initWithCustomView:_menu];
        
        UIButton *_remoteCtrl = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
        [_remoteCtrl setBackgroundImage:[UIImage imageNamed:@"btn_control.png"] forState:UIControlStateNormal];
        [_remoteCtrl addTarget:self action:@selector(btnRemoteCtrlClick) forControlEvents:UIControlEventTouchDown];
        UIBarButtonItem *btnRemoteCtrl = [[UIBarButtonItem alloc] initWithCustomView:_remoteCtrl];
        
        [navigationBar pushNavigationItem:barTitle animated:NO];
        [barTitle setLeftBarButtonItem:btnMenu];
        [barTitle setRightBarButtonItem:btnRemoteCtrl];
        
        [navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_nav_jiemu.png"] forBarMetrics:UIBarMetricsDefault];
        
    }
    
    return  self;



}

@end