#import<UIKit/UIkit.h>
#import "XHGridView.h"

@interface UISettingView : UIView<XHGridViewDelegate>
{
    UILabel        * LB_Nav;
    UIView         * VW_Main;
    XHGridView     * GV_App;
    NSMutableArray * MA_App;
    NSMutableArray * MA_TextFields;
    
}

@property(nonatomic,assign) BOOL isHidden;

-(void)saveIPAddress ;

@end