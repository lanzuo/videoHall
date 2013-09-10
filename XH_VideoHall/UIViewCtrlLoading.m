#import "UIViewCtrlLoading.h"
#import <QuartzCore/QuartzCore.h>
@implementation UIViewCtrlLoading

-(id)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        UILabel * bg       = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
        bg.backgroundColor = [UIColor grayColor];
        bg.alpha           = 0.5;
        bg.layer.cornerRadius = 12;
        
        UIActivityIndicatorView * indic = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
        [indic setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
        [indic startAnimating];
        
        [self addSubview:bg];
        [self addSubview:indic];
    }
    return self;
    
}

@end