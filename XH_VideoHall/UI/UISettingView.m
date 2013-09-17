#import "UISettingView.h"
#import "RemoteService.h"



@implementation UISettingView

@synthesize isHidden;

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"shadow_setting.png"]];
        
        MA_App = [[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4", nil];

        
        //add nav view
        {
            LB_Nav                 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 250, 60)];
            LB_Nav.backgroundColor = [UIColor colorWithRed:82/255.0f green:82/255.0f blue:82/255.0f alpha:1];
            LB_Nav.text            = @"设置";
            LB_Nav.font            = [UIFont fontWithName:@"FZLTCXHJW--GB1-0" size:23];
            LB_Nav.textColor       = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1];
            LB_Nav.textAlignment   = UITextAlignmentCenter;
            [self addSubview:LB_Nav];
        }
        
        //add main content view
        {
            VW_Main = [[UIView alloc]initWithFrame:CGRectMake(25, 60, 225, 420)];
           
            [self addSubview:VW_Main];
            [self mainContentLayout];
            
            UITapGestureRecognizer * tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                    action:@selector(tapGRHandle:)];
            tapGR.numberOfTapsRequired     = 1;
            [VW_Main addGestureRecognizer:tapGR];
            
            
            
        }
      
        isHidden = YES;
    }
    
    return self;
}

-(void)mainContentLayout{

    {
        UILabel * LB_Remote = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 196, 60)];
        LB_Remote.text      = @"遥控器";
        LB_Remote.font      = [UIFont fontWithName:@"FZLTCXHJW--GB1-0" size:18];
        [VW_Main addSubview:LB_Remote];
        
        UIImageView * IV_Remote = [[UIImageView alloc]initWithFrame:CGRectMake(-16, 25, 9, 9)];
        IV_Remote.image         = [UIImage imageNamed:@"icon_remote.png"];
        [VW_Main addSubview:IV_Remote];
        
        NSArray * NA_IP = [[NSArray alloc]init];
        
        RemoteService * rs = [RemoteService sharedInstance];
        if (![rs.remoteBoxIP isEqual: @""]) {
            NA_IP = [rs.remoteBoxIP componentsSeparatedByString:@"."];
        }
        
        MA_TextFields = [[NSMutableArray alloc]init];
        UIColor * UC_BgTextField          = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_textField.png"]];
        UITextField * TF_IP_01            = [[UITextField alloc]initWithFrame:CGRectMake(0, 60, 42, 28)];
        TF_IP_01.keyboardType             = UIKeyboardTypeNumberPad;
        TF_IP_01.returnKeyType            = UIReturnKeyNext;
        TF_IP_01.backgroundColor          = UC_BgTextField;
        TF_IP_01.textAlignment            = UITextAlignmentCenter;
        TF_IP_01.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        TF_IP_01.text                     = NA_IP[0];
        [MA_TextFields addObject:TF_IP_01];
        [VW_Main addSubview:TF_IP_01];
        
        UITextField * TF_IP_02            = [[UITextField alloc]initWithFrame:CGRectMake(52, 60, 42, 28)];
        TF_IP_02.keyboardType             = UIKeyboardTypeNumberPad;
        TF_IP_02.returnKeyType            = UIReturnKeyNext;
        TF_IP_02.backgroundColor          = UC_BgTextField;
        TF_IP_02.textAlignment            = UITextAlignmentCenter;
        TF_IP_02.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        TF_IP_02.text                     = NA_IP[1];
        [MA_TextFields addObject:TF_IP_02];
        [VW_Main addSubview:TF_IP_02];
        
        UITextField * TF_IP_03            = [[UITextField alloc]initWithFrame:CGRectMake(104, 60, 42, 28)];
        TF_IP_03.keyboardType             = UIKeyboardTypeNumberPad;
        TF_IP_03.returnKeyType            = UIReturnKeyNext;
        TF_IP_03.backgroundColor          = UC_BgTextField;
        TF_IP_03.textAlignment            = UITextAlignmentCenter;
        TF_IP_03.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        TF_IP_03.text                     = NA_IP[2];
        [MA_TextFields addObject:TF_IP_03];
        [VW_Main addSubview:TF_IP_03];
        
        UITextField * TF_IP_04            = [[UITextField alloc]initWithFrame:CGRectMake(156, 60, 42, 28)];
        TF_IP_04.keyboardType             = UIKeyboardTypeNumberPad;
        TF_IP_04.returnKeyType            = UIReturnKeyDone;
        TF_IP_04.backgroundColor          = UC_BgTextField;
        TF_IP_04.textAlignment            = UITextAlignmentCenter;
        TF_IP_04.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        TF_IP_04.text                     = NA_IP[3];
        [MA_TextFields addObject:TF_IP_04];
        [VW_Main addSubview:TF_IP_04];
    }
    
    {
        UILabel * LB_App = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, 196, 60)];
        LB_App.text      = @"视频应用";
        LB_App.font      = [UIFont fontWithName:@"FZLTCXHJW--GB1-0" size:18];
        [VW_Main addSubview:LB_App];
        
        UIImageView * IV_App = [[UIImageView alloc]initWithFrame:CGRectMake(-16, 125, 9, 9)];
        IV_App.image         = [UIImage imageNamed:@"icon_application.png"];
        [VW_Main addSubview:IV_App];

        GV_App = [[XHGridView alloc] initWithFrame:CGRectMake(0, 160, 200, 230)];
        GV_App.backgroundColor  = [UIColor colorWithRed:248/255.0f green:248/255.0f blue:248/255.0f alpha:1];
        GV_App.delegate         = self;
        GV_App.dataSource       = MA_App;
        GV_App.cellMarginRight  = 35;
        GV_App.cellMarginBottom = 15;
        GV_App.gridPaddingLeft  = 20;
        GV_App.gridPaddingTop   = 20;
        GV_App.colNumPerPage    = 2;
        GV_App.rowNumPerPage    = 2;
        [GV_App layoutPerPage];
        [VW_Main addSubview:GV_App];

    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"boxDeviceIPOnChange"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUITextFieldValue:)
                                                 name:@"boxDeviceIPOnChange"
                                               object:nil];

    
}

#pragma mark 实现XHGridView代理方法

/*
 描述 : 实现代理方法layoutGridCell，完成cell的布局
 输入 : cell的索引
 输出 : 无
 */
-(XHGridViewCell *)layoutGridCell:(NSInteger)index
{
    XHGridViewCell * cell     = [[XHGridViewCell alloc]initWithFrame:CGRectMake(0, 0, 60, 90)];
    
    UIView * VW_Disney        = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 90)];
    VW_Disney.backgroundColor = [UIColor clearColor];
    
    UIImageView * IV_Disney   = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    IV_Disney.image           = [UIImage imageNamed:@"icon_disney.png"];
    [VW_Disney addSubview:IV_Disney];
    
    UILabel * LB_Disney       = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 60, 30)];
    LB_Disney.textAlignment   = UITextAlignmentCenter;
    LB_Disney.text            = @"迪斯尼";
    LB_Disney.font            = [UIFont fontWithName:@"FZLTCXHJW--GB1-0" size:14];
    LB_Disney.backgroundColor = [UIColor clearColor];
    [VW_Disney addSubview:LB_Disney];
    
    [cell addSubview:VW_Disney];
    return cell;
    
}

/*
 描述 : 手动输入IP地址点击其他空白区域后，隐藏软键盘并保存输入结果
 输入 : 
 输出 : 无
 */
-(void)tapGRHandle:(UITapGestureRecognizer *) recognizer
{
    [self saveIPAddress];
}

/*
 描述 : 隐藏软键盘并保存输入结果
 输入 :
 输出 : 无
 */
-(void)saveIPAddress
{
    NSMutableArray * MA_IP = [[NSMutableArray alloc]init];
    for (UITextField * currentTextField in MA_TextFields)
    {
        [currentTextField resignFirstResponder];
        [MA_IP addObject:currentTextField.text];        
    }
    NSString * ip = [MA_IP componentsJoinedByString:@"."];
    [RemoteService ModifyBoxIP:ip shouldUpdateUITextField:NO];
}

/*
 描述 : 实现Notification boxDeviceIPOnChange 的事件
 输入 : NSNotification对象
 输出 : 无
 */
-(void)updateUITextFieldValue:(NSNotification*) notification
{

    NSArray * NA_IP = [[NSArray alloc]init];
    NSString * ip = [notification object];
    
    if (![ip isEqual: @""])
    {
        NA_IP = [ip componentsSeparatedByString:@"."];
    }
    int i = 0;
    for (UITextField * currentTextField in MA_TextFields)
    {
        currentTextField.text = NA_IP[i];
        i++;
    }
}


@end