#import "UIRootViewCtrl.h"
#import "UIRemoteViewCtrl.h"
#import "UIDetailViewCtrl.h"
#import "VHAppDelegate.h"
#import "UISearchViewCtrl.h"

@implementation UIRootViewCtrl

#pragma mark 视图加载

-(void)loadView{
    [super loadView];
    [self loadSubView];
}

-(void)loadSubView{

    
    UIView * view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view = view;
    self.navigationController.navigationBarHidden = NO;
    
    videoListDataArr = [[NSMutableArray alloc] init];
    sliderImgArr = [[NSMutableArray alloc] init];
    
    {
        [[self.navigationController navigationBar] setFrame:CGRectMake(0, 0, 320, 60)];
        
        //添加菜单按钮作为leftBarButtonItem
        UIButton *_menu = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
        [_menu setBackgroundImage:[UIImage imageNamed:@"btn_menu.png"] forState:UIControlStateNormal];
        [_menu addTarget:self action:@selector(btnMenuClick) forControlEvents:UIControlEventTouchDown];
        UIBarButtonItem *btnMenu = [[UIBarButtonItem alloc]initWithCustomView:_menu];
        self.navigationItem.leftBarButtonItem = btnMenu;
        
        //添加摇控器按钮作为rightBarButtonItem
        UIButton *_remoteCtrl = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
        [_remoteCtrl setBackgroundImage:[UIImage imageNamed:@"btn_control.png"] forState:UIControlStateNormal];
        [_remoteCtrl addTarget:self action:@selector(btnRemoteCtrlClick) forControlEvents:UIControlEventTouchDown];
        UIBarButtonItem *btnRemoteCtrl = [[UIBarButtonItem alloc] initWithCustomView:_remoteCtrl];
        self.navigationItem.rightBarButtonItem = btnRemoteCtrl;
        
        //没法对self.title的字体进行设置，所以对titleView自定义，设置方正兰亭超细黑为字体样式
        UILabel * ttView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
        ttView.backgroundColor = [UIColor clearColor];
        ttView.textAlignment = UITextAlignmentCenter;
        ttView.textColor = [UIColor whiteColor];
        ttView.font = [UIFont fontWithName:@"FZLTCXHJW--GB1-0" size:23];;
        ttView.text = @"节目";
        self.navigationItem.titleView = ttView;
        
        [[self.navigationController navigationBar] setBackgroundImage:[UIImage imageNamed:@"bg_nav_jiemu.png" ] forBarMetrics:UIBarMetricsDefault];
        //将文字垂直位置上调使之垂直居中
        [[self.navigationController navigationBar] setTitleVerticalPositionAdjustment:-8 forBarMetrics:UIBarMetricsDefault];
    }

    {
        //把搜索区域、推荐大图区域、列表区域都装载到scrollView里
        contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 16, 320, 480-60)];    // 16 = 60 - 44
        [self.view addSubview:contentScrollView];
        [self loadContentScrollView];
    }
    
    {
        settingView = [[UISettingView alloc]initWithFrame:CGRectMake(-250, -44, 250, 480)];          // 导航栏高度为44，Y坐标值起点以导航栏以下为参考点
        [self.view addSubview:settingView];
        
        
    }
    
    ctrlLoading = [[UIViewCtrlLoading alloc]initWithFrame:CGRectMake(120, 200, 80, 80)];
    [self.view addSubview:ctrlLoading];
    
}

/*
 描述 : 加载scrollview，分搜索区域、跑马灯区域、视频列表区域
 输入 : 无
 输出 : 无
 */
-(void)loadContentScrollView {
    
    
    //加载搜索区域
    {
        UIImageView *bgSearchInput = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 49)];
        bgSearchInput.image = [UIImage imageNamed:@"bg_searchInput.png"];
        [contentScrollView addSubview:bgSearchInput];
        searchInput = [[UITextField alloc]initWithFrame:CGRectMake(15, 15, 290, 27)];
        searchInput.placeholder = @"搜索";
        searchInput.font = [UIFont fontWithName:@"FZLTCXHJW--GB1-0" size:16];
        searchInput.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
        searchInput.returnKeyType = UIReturnKeyDone;
        searchInput.clearButtonMode = UITextFieldViewModeWhileEditing;
        searchInput.delegate = self;
        [contentScrollView addSubview:searchInput];
    }
    
    //load slide video
    {
        //[self loadSliderImg];
    }
    
    //load list video
    {

        NSString * videoListAddress = [[VHAppDelegate App].appConfig objectForKey:@"ConfigVideoListAddress"];
        asiRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:videoListAddress]];
        [asiRequest startSynchronous];
        NSError * error;       
        NSDictionary * videoList = [NSJSONSerialization JSONObjectWithData:[asiRequest responseData]
                                                                   options:kNilOptions
                                                                     error:&error];
        videoListDataArr = [[[[videoList objectForKey:@"Response"]
                                         objectForKey:@"Body"]
                                         objectForKey:@"Position"]
                                         objectForKey:@"PositionItems"];
        
        videoListDataArr = [self array_unique:videoListDataArr];
        sliderImgArr = [self getSliderVideosByFilter:videoListDataArr filter:@"LinkType"];
        
        [self loadSliderImg];
        
        int lineCount = ([videoListDataArr count] % 3 == 0) ? ([videoListDataArr count] / 3 ): ([videoListDataArr count] / 3 + 1);
        
        videoListGridView = [[UzysGridView alloc] initWithFrame:CGRectMake(0, 49+187, 320, 145 * lineCount + 10)
                                                       numOfRow:3
                                                   numOfColumns:3
                                                     cellMargin:15];
        videoListGridView.delegate = self;
        videoListGridView.dataSource = self;
        [contentScrollView addSubview:videoListGridView];
        
        [contentScrollView setContentSize:CGSizeMake(320, 49 + 187 + videoListGridView.frame.size.height)];
        //下载图片
        {
            asiQueue = [[ASINetworkQueue alloc]init];
            int i = 0;
            for (NSDictionary * item in videoListDataArr) {
                NSString * imgUrl = [NSString stringWithFormat:@"%@%@",[[VHAppDelegate App].appConfig objectForKey:@"ConfigImgAddress"],[item objectForKey:@"BigImageUrl"] ];
                ASIHTTPRequest * imgRequest = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:imgUrl]];
                imgRequest.delegate = self;
                
                [imgRequest setTag:i];
                i++;
                [asiQueue addOperation:imgRequest];
            }
            [asiQueue go];
        }
       
    }    
}

/*
 描述 : 加载跑马灯区域
 输入 : 无
 输出 : 无
 */
- (void)loadSliderImg
{
    NSMutableArray * imgItemArr = [[NSMutableArray alloc]init];
    int i = 0;
    for (NSDictionary * item in sliderImgArr) {
        SGFocusImageItem *imgItem = [[SGFocusImageItem alloc] initWithTitle:[item objectForKey : @"Title" ] image:[UIImage imageNamed:@"thumbnail_0.png"] tag:i];
        [imgItemArr addObject:imgItem];
        i++;
    }
   
    sliderImgFrame = [[SGFocusImageFrame alloc] initWithFrame:CGRectMake(0, 49, 320, 187)
                                                     delegate:self
                                                   ImageItems:imgItemArr];
    sliderImgFrame.delegate = self;
    [contentScrollView addSubview:sliderImgFrame];
}

#pragma mark 数组去重、异步下载回调、过滤到跑马灯数据、跳转到节目详细页面

/*
 描述 : 数据源去重，从接口获取的数据项有重复
 输入 : 无
 输出 : 无
 */
-(NSMutableArray *)array_unique:(NSMutableArray * )arr {

    NSSet * set = [NSSet setWithArray:arr];
    NSMutableArray * res = [[NSMutableArray alloc]init];
    for (NSDictionary * setDic in set) {
        [res addObject:setDic];
    };
    return res;

}

/*
 描述 : 异步下载图片的回调，下载到图片后显示在指定的videoListGridViewCell上
 输入 : 无
 输出 : 无
 */ 
static int sliderIndex = 0;
-(void)requestFinished:(ASIHTTPRequest *)imgRequest{
    
    UIImage * img = [UIImage imageWithData:[imgRequest responseData]];    
    UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 86, 105)];
    imgView.image = img;
    NSInteger m = imgRequest.tag;
    
    [[videoListGridView.cellInfo objectAtIndex:m] addSubview:imgView];
    for (UIView * subview in [[videoListGridView.cellInfo objectAtIndex:m] subviews]) {
        if ([[subview class] isSubclassOfClass:[UIActivityIndicatorView class]]){
            [subview removeFromSuperview];
        }
    }
    
    /*for (int i = 0,k = [sliderImgArr count]; i<k; i++) {
        if ([[videoListDataArr objectAtIndex:m]objectForKey:@"Uri"] == [[sliderImgArr objectAtIndex:i ] objectForKey:@"Uri"] ) {
            [[sliderImgFrame.sliderImages objectAtIndex:i] setBackgroundImage:img forState:UIControlStateNormal];
        }
    }*/
    if (sliderIndex < [sliderImgArr count]) {
        [[sliderImgFrame.sliderImages objectAtIndex:sliderIndex] setBackgroundImage:img forState:UIControlStateNormal];
        sliderIndex++;
    }

    
    
}

/*
 描述 : 过滤到跑马灯数据
 输入 : 源数据、过滤字段
 输出 : 过滤后的数组
 */
-(NSMutableArray *)getSliderVideosByFilter:(NSMutableArray * )arr filter:(NSString *)filter {
    
    NSMutableArray * res = [[NSMutableArray alloc]init];  
    /*for (NSDictionary * item in arr) {
        NSNumber *linkType = [item objectForKey:filter];
        if ([linkType intValue] == 4) {
            [res addObject:item];
        }
    }*/
    for (int i = 0; i<4; i++) {
        [res addObject:[arr objectAtIndex:i]];
    }
    
    return res;
}

/*
 描述 : 跳转到节目详细页面
 输入 : 节目数据
 输出 : 无
 */
-(void)swithToDetailViewCtrl : (NSDictionary * )video {
    UIDetailViewCtrl * detail = [UIDetailViewCtrl initWithVideo:[video objectForKey:@"Title"]
                                                       VideoImg:[video objectForKey:@"BigImageUrl"]
                                                      VideoDesc:[video objectForKey:@"Desc"]
                                                       VideoUri:[video objectForKey:@"Uri"] ];
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark SGFocusImageFrameDelegate代理方法
/*
  描述 : 实现SGFocusImageFrameDelegate的方法，响应跑马灯图片点击事件，跳转到节目详细页面
  输入 : 跑马灯图片的索引值
  输出 : 无
 */
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame didSelectItemIndex:(NSInteger)index
{
    NSDictionary * video = sliderImgArr[index];
    //NSLog(@"%d",index);
    [self swithToDetailViewCtrl:video];
}

#pragma mark UzysGridViewDelegate代理方法

/*
 描述 : 实现UzysGridViewDelegate的方法，获取有多少条数据
 输入 : UzysGridView实例
 输出 : 返回视频列表的长度
 */
-(NSInteger)numberOfCellsInGridView:(UzysGridView *)gridview{
    return [videoListDataArr count];
}

/*
 描述 : 实现UzysGridViewDelegate的方法，完成UzysGridViewCell的布局
 输入 : UzysGridView实例、要完成布局的UzysGridViewCell的索引
 输出 : 返回一个UzysGridViewCell实例
 */
-(UzysGridViewCell *)gridView:(UzysGridView *)gridview cellAtIndex:(NSUInteger)index{
    NSDictionary * videoItem = [videoListDataArr objectAtIndex:index];

    UzysGridViewCell *gridviewCell = [[UzysGridViewCell alloc]initWithFrame:CGRectNull];
    [gridviewCell setIndex:index];
    
    UIActivityIndicatorView * act = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(33, 43, 20, 20)];
    [act setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [gridviewCell addSubview:act];
    [act startAnimating];
    
    UILabel * labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 105, 86, 30)];
    labelTitle.textAlignment = UITextAlignmentCenter;
    [labelTitle setFont:[UIFont fontWithName:@"FZLTCXHJW--GB1-0" size:14]];
    [labelTitle setText:[videoItem objectForKey:@"Title"]];
    [gridviewCell addSubview:labelTitle];
  
    return gridviewCell;
}

/*
 描述 : 实现UzysGridViewDelegate的方法，响应UzysGridViewCell的点击事件
 输入 : UzysGridView实例、被点击的UzysGridViewCell实例、被点击的UzysGridViewCell的索引
 输出 : 无
 */
-(void) gridView:(UzysGridView *)gridView didSelectCell:(UzysGridViewCell *)cell atIndex:(NSUInteger)index{    
    NSDictionary * video = videoListDataArr[index];
    [self swithToDetailViewCtrl:video];
}

#pragma mark 导航栏按钮事件响应方法
/*
 描述 : 响应导航栏右侧遥控器按钮点击事件，跳转到摇控器界面
 输入 : 无
 输出 : 无
 */
-(void)btnRemoteCtrlClick {
    
    [self.view addSubview:ctrlLoading];
    [NSTimer scheduledTimerWithTimeInterval: 3.0
                                     target: self
                                   selector: @selector(pushToRemoteCtrl:)
                                   userInfo: nil
                                    repeats: NO];

}

-(void)pushToRemoteCtrl:(NSTimer * )timer {
    UIRemoteViewCtrl * remoteViewCtrl = [[UIRemoteViewCtrl alloc]init];
    [self.navigationController pushViewController:remoteViewCtrl animated:YES];

}


/*
 描述 : 响应导航栏左侧菜单按钮点击事件，显示或隐藏菜单界面
 输入 : 无
 输出 : 无
 */
-(void)btnMenuClick {

    if (settingView.isHidden) {
        [UIView animateWithDuration:0.3 animations:^(void){
            [self.navigationController navigationBar].frame = CGRectMake(250, 0, 320, 60);
            contentScrollView.frame = CGRectMake(250, 16, 320, 420);
                  settingView.frame = CGRectMake(0, -44, 250, 480);
            
               settingView.isHidden = NO;          
        } completion:nil];
        
    }else{   
        [UIView animateWithDuration:0.3 animations:^(void){
            [self.navigationController navigationBar].frame = CGRectMake(0, 0, 320, 60);
            contentScrollView.frame = CGRectMake(0, 16, 320, 420);
                  settingView.frame = CGRectMake(-250, -44, 250, 480);
            
               settingView.isHidden = YES;           
        } completion:nil];
        [settingView saveIPAddress];    //保存IP地址
        
    }

}

#pragma mark 搜索键盘代理方法

- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [searchInput resignFirstResponder];
    NSString * keyWord = searchInput.text;
    keyWord = [keyWord stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (![keyWord isEqualToString:@""]) {
        UISearchViewCtrl * searchView = [UISearchViewCtrl initWithKeyWord:keyWord];
        [self.navigationController pushViewController:searchView animated:YES];
    }
       
    return  NO;

}


#pragma mark viewDidLoad,viewWillApperr,viewDidAppear,viewWillDisappear,viewDidDisappear,didReceiveMemoryWarning

-(void)viewDidLoad{
    [super viewDidLoad];
    NSLog(@"rootViewCtrl frame : %@ ",NSStringFromCGRect(self.view.frame));
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [ctrlLoading removeFromSuperview];
}



-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

-(void)didReceiveMemoryWarning{
    NSLog(@"receive memory warning...");
}




@end