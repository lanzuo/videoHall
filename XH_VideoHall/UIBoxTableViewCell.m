#import "UIBoxTableViewCell.h"


@implementation UIBoxTableViewCell

@synthesize ipAddress = IPAddress;
@synthesize accessor = Accessor;
@synthesize btn = Btn;

-(id)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        //[Btn addSubview:IPAddress];
        
        //[self addSubview:Btn];
      
        //[self addSubview:Accessor];
        
        
    }
    
    return self;
}


@end