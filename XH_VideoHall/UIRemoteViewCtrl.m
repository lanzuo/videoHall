#import "UIRemoteViewCtrl.h"
#import "VHAppDelegate.h"
#import "Client.h"

@implementation UIRemoteViewCtrl

@synthesize playUrl = PlayUrl;
 
-(void)loadView{
    
    [self.navigationController navigationBar].hidden = YES;
    UIView* view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view = view;
    
    //layout
    self.view.backgroundColor = [UIColor blackColor];
    remoteCtrlWrapper = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    [self.view addSubview:remoteCtrlWrapper];
    
    // add remoteCtrlWrapper
    {
        UIButton * btn_left = [[UIButton alloc]initWithFrame:CGRectMake(15, 150, 100, 100)];
        [btn_left setBackgroundImage:[UIImage imageNamed:@"btn_arrow_left_normal.png"] forState:UIControlStateNormal];
        [btn_left setBackgroundImage:[UIImage imageNamed:@"btn_arrow_left_highlight.png"] forState:UIControlStateHighlighted];
        [btn_left setTag: RC_KEYCODE_LEFT];
        [btn_left addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchDown];
        [btn_left addTarget:self action:@selector(btnClickedOver:) forControlEvents:UIControlEventTouchUpInside];
        [remoteCtrlWrapper addSubview:btn_left];
        
        UIButton * btn_right = [[UIButton alloc]initWithFrame:CGRectMake(320-115, 150, 100, 100)];
        [btn_right setBackgroundImage:[UIImage imageNamed:@"btn_arrow_right_normal.png"] forState:UIControlStateNormal];
        [btn_right setBackgroundImage:[UIImage imageNamed:@"btn_arrow_right_highlight.png"] forState:UIControlStateHighlighted];
        [btn_right setTag:  RC_KEYCODE_RIGHT];
        [btn_right addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchDown];
        [btn_right addTarget:self action:@selector(btnClickedOver:) forControlEvents:UIControlEventTouchUpInside];
        [remoteCtrlWrapper addSubview:btn_right];
        
        // add up button
        UIButton * btn_up = [[UIButton alloc]initWithFrame:CGRectMake(110, 40, 100, 100)];
        [btn_up setBackgroundImage:[UIImage imageNamed:@"btn_arrow_up_normal.png"] forState:UIControlStateNormal];
        [btn_up setBackgroundImage:[UIImage imageNamed:@"btn_arrow_up_highlight.png"] forState:UIControlStateHighlighted];
        [btn_up setTag: RC_KEYCODE_UP];
        [btn_up addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchDown];
        [btn_up addTarget:self action:@selector(btnClickedOver:) forControlEvents:UIControlEventTouchUpInside];
        [remoteCtrlWrapper addSubview:btn_up];
        
        // add down button
        UIButton * btn_down = [[UIButton alloc]initWithFrame:CGRectMake(110, 260, 100, 100)];
        [btn_down setBackgroundImage:[UIImage imageNamed:@"btn_arrow_down_normal.png"] forState:UIControlStateNormal];
        [btn_down setBackgroundImage:[UIImage imageNamed:@"btn_arrow_down_highlight.png"] forState:UIControlStateHighlighted];
        [btn_down setTag: RC_KEYCODE_DOWN];
        [btn_down addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchDown];
        [btn_down addTarget:self action:@selector(btnClickedOver:) forControlEvents:UIControlEventTouchUpInside];
        [remoteCtrlWrapper addSubview:btn_down];
        
        // add home button
        UIButton * btn_homepage = [[UIButton alloc]initWithFrame:CGRectMake(0,380, 100, 100)];
        [btn_homepage setBackgroundImage:[UIImage imageNamed:@"btn_homepage_normal.png"] forState:UIControlStateNormal];
        [btn_homepage setBackgroundImage:[UIImage imageNamed:@"btn_homepage_highlight.png"] forState:UIControlStateHighlighted];
        [btn_homepage setTag: RC_KEYCODE_HOME];
        [btn_homepage addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchDown];
        [btn_homepage addTarget:self action:@selector(btnClickedOver:) forControlEvents:UIControlEventTouchUpInside];
        [remoteCtrlWrapper addSubview:btn_homepage];
        
        // add back button
        UIButton * btn_back = [[UIButton alloc]initWithFrame:CGRectMake(220, 380, 100, 100)];
        [btn_back setBackgroundImage:[UIImage imageNamed:@"btn_back_normal.png"] forState:UIControlStateNormal];
        [btn_back setBackgroundImage:[UIImage imageNamed:@"btn_back_highlight.png"] forState:UIControlStateHighlighted];
        [btn_back setTag: RC_KEYCODE_BACK];
        [btn_back addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchDown];
        [btn_back addTarget:self action:@selector(btnClickedOver:) forControlEvents:UIControlEventTouchUpInside];
        [remoteCtrlWrapper addSubview:btn_back];
        
        
        // add top touch area
        UILabel * topTouchArea = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
        topTouchArea.backgroundColor = [UIColor clearColor];
        topTouchArea.userInteractionEnabled = YES;
        UIPanGestureRecognizer *panAction = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(topPanAction:)];
        [topTouchArea addGestureRecognizer:panAction];
        [remoteCtrlWrapper addSubview:topTouchArea];
        
        // add bottom touch area
        UILabel * bottomTouchArea = [[UILabel alloc]initWithFrame:CGRectMake(100, 420, 120, 60)];
        bottomTouchArea.backgroundColor = [UIColor clearColor];
        bottomTouchArea.userInteractionEnabled = YES;
        UIPanGestureRecognizer *bottomPan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(bottomPanAction:)];
        [bottomTouchArea addGestureRecognizer:bottomPan];
        [self.view addSubview:bottomTouchArea];
        
        //swipte action
        remoteCtrlWrapper.userInteractionEnabled = YES;
        UISwipeGestureRecognizer * swipeGR;
        swipeGR = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
        swipeGR.direction = UISwipeGestureRecognizerDirectionUp;
        swipeGR.delegate = self;
        [remoteCtrlWrapper addGestureRecognizer:swipeGR];
        
        swipeGR = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
        swipeGR.direction = UISwipeGestureRecognizerDirectionDown;
        swipeGR.delegate = self;
        [remoteCtrlWrapper addGestureRecognizer:swipeGR];
        
        swipeGR = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
        swipeGR.direction = UISwipeGestureRecognizerDirectionLeft;
        swipeGR.delegate = self;
        [remoteCtrlWrapper addGestureRecognizer:swipeGR];
        
        swipeGR = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
        swipeGR.direction = UISwipeGestureRecognizerDirectionRight;
        swipeGR.delegate = self;
        [remoteCtrlWrapper addGestureRecognizer:swipeGR];
        
        
        //single tap action
        UITapGestureRecognizer * singleTapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapAction:)];
        [singleTapGR setNumberOfTapsRequired:1];
        singleTapGR.delegate = self;
        singleTapGR.cancelsTouchesInView = NO;
        [singleTapGR requireGestureRecognizerToFail:swipeGR ];
        [remoteCtrlWrapper addGestureRecognizer:singleTapGR];
        
        //double tap action
        /*UITapGestureRecognizer * doubleTapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapAction:)];
        [doubleTapGR setNumberOfTapsRequired:2];
        doubleTapGR.cancelsTouchesInView = NO;
        [remoteCtrlWrapper addGestureRecognizer:doubleTapGR];*/
        
    }
    
    // add quit button
    {
        btn_quit = [[UIButton alloc]initWithFrame:CGRectMake(0, -60, 320, 60)];
        UILabel * btn_quit_label = [[UILabel alloc]initWithFrame:CGRectMake(0,0, 320, 60)];
        
        btn_quit_label.font = [UIFont fontWithName:@"FZLTCXHJW--GB1-0" size:23];
        btn_quit_label.textColor = [UIColor whiteColor];
        btn_quit_label.textAlignment = UITextAlignmentCenter;
        
        btn_quit_label.backgroundColor = [UIColor colorWithRed:271/255.0f green:77/255.0f blue:33/255.0f alpha:1];
        btn_quit_label.text = @"退出摇控器";
        btn_quit_label.userInteractionEnabled = NO;
        [btn_quit addSubview:btn_quit_label];
        [btn_quit addTarget:self action:@selector(quitBtnClick) forControlEvents:UIControlEventTouchDown];
        
        [self.view addSubview:btn_quit];
    }
    
    // add applicationView
    {
        applicationPanel = [[applicationView alloc]initWithFrame:CGRectMake(0, 480, 320, 480)];
        [self.view addSubview:applicationPanel];
        
    }

}


#pragma mark view load method

-(void)viewDidLoad{
    
    [super viewDidLoad];

}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    rs = [RemoteService sharedInstance];
    NSLog(@"status : %d",rs.status);
    if (rs.status != connected) {
        [rs connectWithTCP];
        NSString * statusDes= @"";
        switch (rs.status) {
            case scanning:
                statusDes = @"扫描中...";
                
                [[NSNotificationCenter defaultCenter] removeObserver:self
                                                                name:@"ifScanOneBox"
                                                              object:nil];
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(ifScanOneBoxHandle:)
                                                             name:@"ifScanOneBox" object:nil];
                [[NSNotificationCenter defaultCenter] removeObserver:self
                                                                name:@"scanBoxCompletion"
                                                              object:nil];
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(scanBoxCompletionHandle:)
                                                             name:@"scanBoxCompletion"
                                                           object:nil];
                
                boxView = [[UIBoxTableView alloc]initWithFrame:CGRectMake(50, 200, 220, 300)];
                boxView.delegate = self;
                [remoteCtrlWrapper addSubview:boxView];
                
                break;
                
            case connecting:
                statusDes = @"连接中...";
                
                [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getTcpState" object:nil];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTcpStateHandle:) name:@"getTcpState" object:nil];
                
            default:
                break;
        }
        
        
        {
            waitLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 163, 320, 75)];
            waitLabel.backgroundColor = [UIColor clearColor];
            waitLabel.text = statusDes;
            waitLabel.font = [UIFont fontWithName:@"FZLTCXHJW--GB1-0" size:14];
            waitLabel.textColor = [UIColor whiteColor];
            waitLabel.textAlignment = UITextAlignmentCenter;
            [remoteCtrlWrapper addSubview:waitLabel];
            waitIdv = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(150, 150, 20, 20)];
            [remoteCtrlWrapper addSubview:waitIdv];
            [waitIdv startAnimating];
        }
    }//(rs.status == unconnected) end
    
    


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

- (void)viewDidUnload {
    [super viewDidUnload];
    
}

#pragma mark box cell layout (delegate)
-(UIBoxTableViewCell * )layoutBoxCell {
    
    UIBoxTableViewCell * cell = [[UIBoxTableViewCell alloc]initWithFrame:CGRectMake(0, 0, 220, 70)];
    cell.backgroundColor = [UIColor clearColor];
    
    cell.ipAddress = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 220, 70)];
    cell.ipAddress.backgroundColor = [UIColor clearColor];
    cell.ipAddress.textColor = [UIColor whiteColor];
    cell.btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 220, 70)];
    cell.accessor = [[UIImageView alloc]initWithFrame:CGRectMake(220 - 60 , 70 - 10, 60, 60)];
    
    return cell;
}


#pragma mark box cell click method
-(void)boxCellClick:(NSString *)ipAddress {
    
    waitLabel.text = @"正在连接中...";
    [boxView removeFromSuperview];
    rs.remoteBoxIP = ipAddress;
    [rs connectWithTCP];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"getTcpState"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getTcpStateHandle:)
                                                 name:@"getTcpState"
                                               object:nil];
}



/*
name : checkRemoteServiceState
description :

*/

-(void)ifScanOneBoxHandle:(NSNotification*) notification{

    Client * oneBox  = [notification object];
    [boxView pushOneBox:oneBox];

}

-(void)scanBoxCompletionHandle:(NSNotification*) notification{
    
    
    NSString * tcpStateDes = @"";
    NSInteger boxCount = [[notification object] intValue];
    if (boxCount == 0) {
        tcpStateDes = @"扫描结束，找不到盒子";
    }else{
        tcpStateDes = @"扫描结束，请选择盒子";
    }
    [self hiddenTipsInfo:tcpStateDes];
    
    
}

/*
 描述 : 判断tcp连接时状态
 输入 : 无
 输出 : 无
 */
-(void)getTcpStateHandle:(NSNotification*) notification{
    
    NSString * tcpStateDes = @"";
    if (rs.status == connected) {
        tcpStateDes = @"连接成功";
        if (![self.playUrl isEqualToString:@""]) {
            [rs sendPlayValue:self.playUrl];
        }
    }
    if (rs.status == unconnected) {
        tcpStateDes = @"连接失败，请检查网络";
    }

    [self hiddenTipsInfo:tcpStateDes];
    
    
}

-(void)hiddenTipsInfo:(NSString *)tipStr{

    waitLabel.text = tipStr;
    [waitIdv removeFromSuperview];
    
    [UIView animateWithDuration:4 animations:^(void){
        waitLabel.alpha = 0;
        
    } completion:nil];

}







//swipe action controls the main staff,such as player's action and EPG's control

-(void)swipeAction:(UISwipeGestureRecognizer * )recognizer{
    
    switch (recognizer.direction) {
        case UISwipeGestureRecognizerDirectionDown:
            if (rs.status == connected) {
               
                [rs sendKeyValue:RC_KEYCODE_DOWN action:0 eventKey:EVENT_KEY];
                if (UIGestureRecognizerStateBegan == recognizer.state ) {
                    [rs sendKeyValue:RC_KEYCODE_DOWN action:0 eventKey:EVENT_KEY];
                }
                if (UIGestureRecognizerStateEnded == recognizer.state ) {
                    [rs sendKeyValue:RC_KEYCODE_DOWN action:1 eventKey:EVENT_KEY];
                }
                
                
            }
            break;
        case UISwipeGestureRecognizerDirectionLeft:
            if (rs.status == connected) {
                [rs sendKeyValue:RC_KEYCODE_LEFT action:0 eventKey:EVENT_KEY];
                if (UIGestureRecognizerStateBegan == recognizer.state ) {
                    [rs sendKeyValue:RC_KEYCODE_LEFT action:0 eventKey:EVENT_KEY];
                }
                if (UIGestureRecognizerStateEnded == recognizer.state ) {
                    [rs sendKeyValue:RC_KEYCODE_LEFT action:1 eventKey:EVENT_KEY];
                }
                
            }
            break;
        case UISwipeGestureRecognizerDirectionRight:
            if (rs.status == connected) {
                [rs sendKeyValue:RC_KEYCODE_RIGHT action:0 eventKey:EVENT_KEY];
                if (UIGestureRecognizerStateBegan == recognizer.state ) {
                    NSLog(@"%d",__LINE__);
                    [rs sendKeyValue:RC_KEYCODE_RIGHT action:0 eventKey:EVENT_KEY];
                }
                if (UIGestureRecognizerStateEnded == recognizer.state ) {
                    [rs sendKeyValue:RC_KEYCODE_RIGHT action:1 eventKey:EVENT_KEY];
                }
                
            }
            break;
        case UISwipeGestureRecognizerDirectionUp:
            if (btn_quit.frame.origin.y >= 0) {
                [UIView animateWithDuration:0.2 animations:^(void){
                    btn_quit.frame = CGRectMake(0, -60, btn_quit.bounds.size.width, btn_quit.bounds.size.height);
                    remoteCtrlWrapper.frame = CGRectMake(0, 0, remoteCtrlWrapper.bounds.size.width, remoteCtrlWrapper.bounds.size.height);
                } completion:nil];
            }else{
                if (rs.status == connected) {
                    
                    [rs sendKeyValue:RC_KEYCODE_UP action:0 eventKey:EVENT_KEY];
                    if (UIGestureRecognizerStateBegan == recognizer.state ) {
                        [rs sendKeyValue:RC_KEYCODE_UP action:0 eventKey:EVENT_KEY];
                    }
                    if (UIGestureRecognizerStateEnded == recognizer.state ) {
                        [rs sendKeyValue:RC_KEYCODE_UP action:1 eventKey:EVENT_KEY];
                    }
                    
                }
            }
            break;
        default:
            break;
    }
    

    
}


//pan action controls the hidden-button's display
-(void)topPanAction:(UIPanGestureRecognizer *) recognizer{
    
    if (UIGestureRecognizerStateBegan == recognizer.state) {
        
        CGRect frame = btn_quit.frame;
        CGPoint point = [recognizer translationInView:self.view];
        
        
        NSLog(@"%f,%f",frame.origin.y,point.y);
            
            if (frame.origin.y <= 0 && point.y >= 0) {
                [UIView animateWithDuration:0.2 animations:^(void){
                    btn_quit.frame = CGRectMake(0, 0, btn_quit.bounds.size.width, btn_quit.bounds.size.height);
                    remoteCtrlWrapper.frame = CGRectMake(0, 60, remoteCtrlWrapper.bounds.size.width, remoteCtrlWrapper.bounds.size.height);
                } completion:nil];
                
            }
            
             if (frame.origin.y >= 0 && point.y <= 0) {
                [UIView animateWithDuration:0.2 animations:^(void){
                    btn_quit.frame = CGRectMake(0, -60, btn_quit.bounds.size.width, btn_quit.bounds.size.height);
                    remoteCtrlWrapper.frame = CGRectMake(0, 0, remoteCtrlWrapper.bounds.size.width, remoteCtrlWrapper.bounds.size.height);
                } completion:nil];
            }
      
    }
 
}

//pan action controls the application-panel's display
-(void)bottomPanAction:(UIPanGestureRecognizer *) recognizer{

    CGPoint point = [recognizer translationInView:self.view];
    
    if (point.y <= 0) {

        [UIView animateWithDuration:0.2 animations:^(void){
            applicationPanel.frame = CGRectMake(0, 0, applicationPanel.bounds.size.width, applicationPanel.bounds.size.height);
           
        } completion:nil];
    }


}

// tap action controls the single click action
-(void)singleTapAction:(UITapGestureRecognizer *) recognizer{

    
    if (rs.status == connected) {
        [rs sendKeyValue:RC_KEYCODE_CENTER action:0 eventKey:EVENT_KEY];
        if (UIGestureRecognizerStateBegan == recognizer.state ) {
            [rs sendKeyValue:RC_KEYCODE_CENTER action:0 eventKey:EVENT_KEY];
        }
        if (UIGestureRecognizerStateEnded == recognizer.state ) {
            [rs sendKeyValue:RC_KEYCODE_CENTER action:1 eventKey:EVENT_KEY];
        }
    }
}

// tap action controls the single click action
-(void)doubleTapAction:(UITapGestureRecognizer *) recognizer{
    
    NSLog(@"tap count : %d",recognizer.numberOfTapsRequired);
    if (rs.status == connected) {
        
        [rs sendKeyValue:RC_KEYCODE_CENTER action:0 eventKey:EVENT_KEY];
    }
}

-(void)quitBtnClick{
    
    [self.navigationController navigationBar].hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)btnClicked:(id )sender {
    
   
    UIButton *myBtn=(UIButton *) sender;
    
    NSInteger actionValue = 0;
    

    if (rs.status == connected) {
        
        [rs sendKeyValue:myBtn.tag action:actionValue eventKey:EVENT_KEY];
        
    }

    
}
-(void)btnClickedOver:(id)sender
{
    //UIButton *seledBtn = (UIButton *)sender;
    //NSInteger BtnTag = seledBtn.tag;
    //[self sendKeyValue:BtnTag action:1];
    UIButton *myBtn=(UIButton *) sender;
    
    NSInteger actionValue = 1;

    
    if (rs.status == connected) {
        
        [rs sendKeyValue:myBtn.tag action:actionValue eventKey:EVENT_KEY];
        
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    return YES;
}



@end