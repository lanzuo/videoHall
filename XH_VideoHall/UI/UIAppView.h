#import<UIKit/UIKit.h>
#import "XHGridView.h"

@interface UIAppView : UIView<XHGridViewDelegate>

{

    XHGridView * applicationGridView;
    NSMutableArray * applicationMA;
    UIPanGestureRecognizer * panGR;

}

@end