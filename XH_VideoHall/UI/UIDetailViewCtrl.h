#import <UIKit/UIKit.h>
#import "RemoteService.h"
#import "UIViewCtrlLoading.h"


@interface UIDetailViewCtrl : UIViewController
{
    UIImageView             * VideoPost;
    UILabel                 * VideoTitle;
    UILabel                 * VideoMeta;    
    UIButton                * VideoBtnPlay;
    UIActivityIndicatorView * Indic;
    UIViewCtrlLoading       * CtrlLoading;

}

@property (nonatomic,assign) NSInteger videoID;
@property (nonatomic,retain) NSString * videoTitle;
@property (nonatomic,retain) NSString * videoPost;
@property (nonatomic,retain) NSString * videoInstr;
@property (nonatomic,retain) NSString * videoPlayUri;
+(id)initWithVideo:videoName VideoImg:videoImg VideoDesc:videoDesc VideoUri:videoUri;
@end