#import "UIKit/UIKit.h"

@interface UISearchViewCtrl : UIViewController<UITextFieldDelegate>
{
    NSString       * KeyWord;
    UITextField    * searchInput;
    UIScrollView   * contentScrollView;
    NSMutableArray * videoListDataArr;
}

@property(nonatomic,retain) NSString * keyWord;
+(UISearchViewCtrl *) initWithKeyWord:(NSString *)keyWord;

@end