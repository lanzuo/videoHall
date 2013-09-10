#import <UIKit/UIKit.h>


@interface UIBoxTableViewCell : UIView
{
    UILabel * IPAddress;
    UIImageView * Accessor;
    UIButton * Btn;
}

@property(nonatomic,retain) UILabel * ipAddress;
@property(nonatomic,retain) UIImageView * accessor;
@property(nonatomic,retain) UIButton * btn;


@end