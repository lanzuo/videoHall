#import<UIKit/UIkit.h>
#import "XHGridView.h"

@interface SettingView : UIView<XHGridViewDelegate>
{
    UILabel        * nav;
    UIView         * mainContent;
    XHGridView     * applicationGridView;
    NSMutableArray * applicationMA;
    NSMutableArray * UITextFieldArray;
    
}

@property(nonatomic,assign) BOOL isHidden;

-(void)saveIPAddress ;

@end