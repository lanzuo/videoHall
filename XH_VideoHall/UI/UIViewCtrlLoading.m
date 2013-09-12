#import "UIViewCtrlLoading.h"
#import <QuartzCore/QuartzCore.h>
@implementation UIViewCtrlLoading

-(id)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame])
    {
        UILabel * LB_Bg       = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
        LB_Bg.backgroundColor = [UIColor grayColor];
        LB_Bg.alpha           = 0.5;
        LB_Bg.layer.cornerRadius = 12;
        
        UIActivityIndicatorView * AI_Loading = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
        [AI_Loading setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
        [AI_Loading startAnimating];
        
        [self addSubview:LB_Bg];
        [self addSubview:AI_Loading];
    }
    return self;
    
}

@end