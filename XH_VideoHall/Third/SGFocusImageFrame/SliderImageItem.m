

#import "SliderImageItem.h"

@implementation SliderImageItem
@synthesize title =  _title;
@synthesize defaultImage =  _defaultImage;
@synthesize tag =  _tag;

- (void)dealloc
{
    // [_title release];
    //[_image release];
    // [super dealloc];
}

- (id)initWithTitle:(NSString *)title imageUrl:(NSString *)imageUrl defaultImage:(UIImage *)defaultImage tag:(NSInteger)tag
{
    self = [super init];
    if (self) {

    }
    
    return self;
}

@end
