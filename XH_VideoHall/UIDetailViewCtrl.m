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
    ttView.textAlignment = UITextAlignmentCenter;
    ttView.textColor = [UIColor whiteColor];
    ttView.font = [UIFont fontWithName:@"FZLTCXHJW--GB1-0" size:23];
    ttView.text = @"节目详情";
    self.navigationItem.titleView = ttView;

    UIButton * backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    UIImageView * backBtnImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, -10, 60, 60)];
    backBtnImg.image = [UIImage imageNamed:@"btn-back.png"];
    [backBtn addSubview:backBtnImg];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem * backBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backBtnItem;
    
    
    _video_post = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 187)];
    NSString * imgUrl = [NSString stringWithFormat:@"%@%@",[[VHAppDelegate App].serviceConfig objectForKey:@"ConfigImgAddress"],self.videoPost];
    ASIHTTPRequest * imgRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:imgUrl]];
    [imgRequest setDelegate:self];
    [imgRequest startAsynchronous];
    [self.view addSubview:_video_post];
    
    _indic = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(150, 93, 20, 20)];
    [_indic setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [_indic startAnimating];
    [self.view addSubview:_indic];
    
    
    _video_title = [[UILabel alloc]initWithFrame:CGRectMake(15, 187, 290, 80)];
    _video_title.backgroundColor = [UIColor clearColor];
    _video_title.textColor = [UIColor blackColor];
    _video_title.text = self.videoTitle;
    _video_title.font = [UIFont fontWithName:@"FZLTCXHJW--GB1-0" size:32];
    [self.view addSubview:_video_title];
    
    
    
    _video_meta = [[UILabel alloc]initWithFrame:CGRectMake(15, 247, 290, 80)];
    _video_meta.backgroundColor = [UIColor clearColor];
    _video_meta.font = [UIFont fontWithName:@"FZLTCXHJW--GB1-0" size:22];
    _video_meta.textColor = [UIColor blackColor];
    _video_meta.text = self.videoInstr;
    _video_meta.numberOfLines = 2;
    [self.view addSubview:_video_meta];
    
    _video_btn_play = [[UIButton alloc]initWithFrame:CGRectMake(0,480-60-44, 320, 60)];
    UILabel * btn_play_label = [[UILabel alloc]initWithFrame:CGRectMake(0,0, 320, 60)];
    btn_play_label.font = [UIFont fontWithName:@"FZLTCXHJW--GB1-0" size:23];
    btn_play_label.textColor = [UIColor whiteColor];
    btn_play_label.textAlignment = UITextAlignmentCenter;
    btn_play_label.backgroundColor = [UIColor colorWithRed:271/255 green:77/255 blue:33/255 alpha:1];
    btn_play_label.text = @"播放";
    btn_play_label.userInteractionEnabled = NO;
    [_video_btn_play addSubview:btn_play_label];
    [_video_btn_play addTarget:self action:@selector(playBtnClick) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_video_btn_play];
    
    

}

-(void)backBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)playBtnClick {
    
    RemoteService * rs = [RemoteService sharedInstance];
    if (rs.status == unconnected) {
        [rs connectWithTCP];
    }
    
    if (rs.status == connected) {
        [[RemoteService sharedInstance] sendPlayValue:self.videoPlayUri];
        UIRemoteViewCtrl * remoteViewCtrl = [[UIRemoteViewCtrl alloc]init];
        [self.navigationController pushViewController:remoteViewCtrl animated:YES];
    }else{
    
        NSLog(@"摇控器未连接");
    }
    
}




@end