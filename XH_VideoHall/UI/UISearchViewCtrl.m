#import "UISearchViewCtrl.h"
#import "ASIHTTPRequest.h"
#import "VHAppDelegate.h"

@implementation UISearchViewCtrl

@synthesize keyWord = KeyWord;

+(UISearchViewCtrl *) initWithKeyWord:(NSString *)keyWord{

    UISearchViewCtrl * searchView = [[UISearchViewCtrl alloc]init];
    searchView.keyWord = keyWord;
    
    return searchView;
}


-(void)loadView{
    UIView * view = [[UIView alloc]initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view = view;
    videoListDataArr = [[NSMutableArray alloc]init];
}

-(void)viewDidLoad {
    
    [super viewDidLoad];
    UILabel * ttView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 160, 60)];
    ttView.backgroundColor = [UIColor clearColor];
    ttView.textAlignment = UITextAlignmentCenter;
    ttView.textColor = [UIColor whiteColor];
    ttView.font = [UIFont fontWithName:@"FZLTCXHJW--GB1-0" size:23];
    ttView.text = @"搜索";
    self.navigationItem.titleView = ttView;
    
    UIButton * backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    UIImageView * backBtnImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, -10, 60, 60)];
    backBtnImg.image = [UIImage imageNamed:@"btn-back.png"];
    [backBtn addSubview:backBtnImg];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem * backBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backBtnItem;
    
    contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 16, 320, 480 - 60)];
    [self.view addSubview:contentScrollView];
    
    //加载搜索区域
    {
        UIImageView *bgSearchInput = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 49)];
        bgSearchInput.image = [UIImage imageNamed:@"bg_searchInput.png"];
        [contentScrollView addSubview:bgSearchInput];           //直接使用searchInput.background会导致输入光标在最左边，视觉效果不好
        searchInput = [[UITextField alloc]initWithFrame:CGRectMake(15, 15, 290, 27)];
        searchInput.placeholder = self.keyWord;
        searchInput.font = [UIFont fontWithName:@"FZLTCXHJW--GB1-0" size:16];
        searchInput.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
        searchInput.returnKeyType = UIReturnKeyDone;
        searchInput.clearButtonMode = UITextFieldViewModeWhileEditing;
        searchInput.delegate = self;
        [contentScrollView addSubview:searchInput];
    }
}

/*
 描述 : 响应导航栏左侧按钮事件，退回到上一个viewController
 输入 : 无
 输出 : 无
 */
-(void)backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 搜索键盘代理方法

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    NSString * keyWord = searchInput.text;
    keyWord = [keyWord stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (![keyWord isEqualToString:@""]) { 
        NSString * searchPostAddress = [[VHAppDelegate App].appConfig objectForKey:@"ConfigSearchPostAddress"];
        ASIHTTPRequest * asiRequest = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:searchPostAddress]];
        NSString * postStr = [NSString stringWithFormat:@"UserGroup=%@&Keywords=%@&SearchMethod=%@&SearchType=%@&PageIndex=%@&PageSize=%d",@"OTT_GROUP$TerOut_6580$test",keyWord,@"111111111111",@"1111111111111111",@"1",20];
        NSData * postData = [postStr dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString * postLength = [NSString stringWithFormat:@"%d",[postData length]];
        [asiRequest setRequestMethod:@"POST"];
        [asiRequest addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
        [asiRequest addRequestHeader:@"Content-Length" value:postLength];
        [asiRequest appendPostData:postData];
        [asiRequest setDelegate:self];
        [asiRequest startAsynchronous];
    }
   
    [searchInput resignFirstResponder];
    
    {
        UIActivityIndicatorView * AI_Loading = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(150, 170, 20, 20)];
        [AI_Loading setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [AI_Loading startAnimating];
        [contentScrollView addSubview:AI_Loading];
    }
    
    return YES;
}

-(void)requestFinished:(ASIHTTPRequest *)request{
    
//    if([contentScrollView.subviews count] > 0)
//    {
//        for (UIView * view in contentScrollView) {
//            if ([view isKindOfClass:[UIActivityIndicatorView class]]) {
//                [view removeFromSuperview];
//            }
//        }    
//    }
    NSLog(@"%d",[request responseStatusCode]);
    NSError * error;
    NSDictionary * videoList = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:&error];
    videoListDataArr = [[[[videoList objectForKey:@"Response"]
                          objectForKey:@"Body"]
                          objectForKey:@"Position"]
                          objectForKey:@"PositionItems"];
    NSLog(@"%@",videoListDataArr);
    NSLog(@"requestFinished : %s",__FUNCTION__);
    
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"%@",[request error]);
}


@end