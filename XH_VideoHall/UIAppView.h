#import<UIKit/UIKit.h>
#import "XHGridView.h"

@interface applicationView : UIView<XHGridViewDelegate>

{

    XHGridView * applicationGridView;
    NSMutableArray * applicationMA;
    UIPanGestureRecognizer * panGR;

}

@end