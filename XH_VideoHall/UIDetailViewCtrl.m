#import <QuartzCore/QuartzCore.h>
#import "UIDetailViewCtrl.h"
#import "VHAppDelegate.h"
#import "RootViewCtrl.h"
#import "UIRemoteViewCtrl.h"
#import "ASIHTTPRequest.h"



@implementation UIDetailViewCtrl

@synthesize videoID,videoTitle,videoPost,videoInstr,videoPlayUri;

+(id)initWithVideo:videoName VideoImg:videoImg VideoDesc:videoDesc VideoUri:videoUri{

    UIDetailViewCtrl * detail = [[UIDetailViewCtrl alloc]init];
    detail.videoTitle = videoName;
    detail.videoPost = videoImg;
    detail.videoInstr = videoDesc;
    detail.videoPlayUri = videoUri;
    return  detail;
}

-(void)loadView{
    [super loadView];
    UIView * view = [[UIView alloc]initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view = view;
}

-(void)viewDidLoad{
    
    [super viewDidLoad];
    UILabel * ttView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 160, 60)];
    ttView.backgroundColor = [UIColor clearColor];
    ttView.textAlignment   = UITextAlignmentCenter;
    ttView.textColor       = [UIColor whiteColor];
    ttView.font            = [UIFont fontWithName:@"FZLTCXHJW--GB1-0" size:23];
    ttView.text            = @"节目详情";
    self.navigationItem.titleView = ttView;

    UIButton * backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    UIImageView * backBtnImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, -10, 60, 60)];
    backBtnImg.image = [UIImage imageNamed:@"btn-back.png"];
    [backBtn addSubview:backBtnImg];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem * backBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backBtnItem;
    
    
    VideoPost = [[UIImageView alloc]initWithFrame:CGRectMake(0, 14, 320, 187)];
    NSString * imgUrl = [NSString stringWithFormat:@"%@%@",[[VHAppDelegate App].serviceConfig objectForKey:@"ConfigImgAddress"],self.videoPost];
    ASIHTTPRequest * imgRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:imgUrl]];
    [imgRequest setDelegate:self];
    [imgRequest startAsynchronous];
    [self.view addSubview:VideoPost];
    
    Indic = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(150, 107, 20, 20)];
    [Indic setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [Indic startAnimating];
    [self.view addSubview:Indic];
    
    
    VideoTitle = [[UILabel alloc]initWithFrame:CGRectMake(15, 201, 290, 80)];
    VideoTitle.backgroundColor = [UIColor clearColor];
    VideoTitle.textColor = [UIColor blackColor];
    VideoTitle.text = self.videoTitle;
    VideoTitle.font = [UIFont fontWithName:@"FZLTCXHJW--GB1-0" size:32];
    [self.view addSubview:VideoTitle];
    
    
    
    VideoMeta = [[UILabel alloc]initWithFrame:CGRectMake(15, 261, 290, 80)];
    VideoMeta.backgroundColor = [UIColor clearColor];
    VideoMeta.font = [UIFont fontWithName:@"FZLTCXHJW--GB1-0" size:22];
    VideoMeta.textColor = [UIColor blackColor];
    VideoMeta.text = self.videoInstr;
    VideoMeta.numberOfLines = 2;
    [self.view addSubview:VideoMeta];
    
    VideoBtnPlay = [[UIButton alloc]initWithFrame:CGRectMake(0,480-60-44, 320, 60)];
    UILabel * btn_play_label = [[UILabel alloc]initWithFrame:CGRectMake(0,0, 320, 60)];
    btn_play_label.font = [UIFont fontWithName:@"FZLTCXHJW--GB1-0" size:23];
    btn_play_label.textColor = [UIColor whiteColor];
    btn_play_label.textAlignment = UITextAlignmentCenter;
    btn_play_label.backgroundColor = [UIColor colorWithRed:271/255 green:77/255 blue:33/255 alpha:1];
    btn_play_label.text = @"播放";
    btn_play_label.userInteractionEnabled = NO;
    [VideoBtnPlay addSubview:btn_play_label];
    [VideoBtnPlay addTarget:self action:@selector(playBtnClick) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:VideoBtnPlay];
    
    CtrlLoading = [[UIViewCtrlLoading alloc]initWithFrame:CGRectMake(120, 280, 80, 80)];
    [self.view addSubview:CtrlLoading];
    
    

}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [CtrlLoading removeFromSuperview];
}

-(void)backBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)playBtnClick {
    [self.view addSubview:CtrlLoading];
    [NSTimer scheduledTimerWithTimeInterval: 3.0
                                     target: self
                                   selector: @selector(pushToRemoteCtrl:)
                                   userInfo: nil
                                    repeats: NO];
    
   
}


-(void)pushToRemoteCtrl:(NSTimer * )timer {
    UIRemoteViewCtrl * remoteViewCtrl = [[UIRemoteViewCtrl alloc]init];
    RemoteService * rs = [RemoteService sharedInstance];
    
    if (rs.status == connected) {
        [rs sendPlayValue:self.videoPlayUri];
    }else{
        remoteViewCtrl.playUrl = self.videoPlayUri;
    }
    
    [self.navigationController pushViewController:remoteViewCtrl animated:YES];
}




- (void)requestFinished:(ASIHTTPRequest *) request {

    UIImage * img = [UIImage imageWithData:[request responseData]];
    VideoPost.image = img;
    [Indic stopAnimating];
    [Indic removeFromSuperview];

}




@end