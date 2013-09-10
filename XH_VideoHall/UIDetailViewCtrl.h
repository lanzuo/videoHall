#import <UIKit/UIKit.h>
#import "RemoteService.h"


@interface UIDetailViewCtrl : UIViewController{

    UIImageView * _video_post;
    
    UILabel * _video_title;
    
    UILabel * _video_meta;
    
    UIButton * _video_btn_play;
    
    UIActivityIndicatorView * _indic;
    
    //AsyncSocket * tcpSocket;

}

@property (nonatomic,assign) NSInteger videoID;
@property (nonatomic,retain) NSString * videoTitle;
@property (nonatomic,retain) NSString * videoPost;
@property (nonatomic,retain) NSString * videoInstr;
@property (nonatomic,retain) NSString * videoPlayUri;
+(id)initWithVideo:videoName VideoImg:videoImg VideoDesc:videoDesc VideoUri:videoUri;
@end