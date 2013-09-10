#import <UIKit/UIKit.h>

@interface SliderImageItem : NSObject

@property (nonatomic, retain)  NSString     *title;
@property (nonatomic, retain)  NSString      *imageUrl;
@property (nonatomic, assign)  NSInteger     tag;
@property (nonatomic, retain)  UIImage      *defaultImage;

- (id)initWithTitle:(NSString *)title imageUrl:(NSString *)imageUrl defaultImage:(UIImage *)defaultImage tag:(NSInteger)tag;

@end
