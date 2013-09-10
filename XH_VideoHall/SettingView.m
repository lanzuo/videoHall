#import "SettingView.h"
#import "RemoteService.h"



@implementation SettingView

@synthesize isHidden;

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"shadow_setting.png"]];
        
        applicationMA = [[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4", nil];

        
        //add nav view
        {
            nav = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 250, 60)];
            nav.backgroundColor = [UIColor colorWithRed:82/255.0f green:82/255.0f blue:82/255.0f alpha:1];
            nav.text = @"设置";
            nav.font = [UIFont fontWithName:@"FZLTCXHJW--GB1-0" size:23];
            nav.textColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1];
            nav.textAlignment = UITextAlignmentCenter;
            [self addSubview:nav];
        }
        
        //add main content view
        {
            mainContent = [[UIView alloc]initWithFrame:CGRectMake(25, 60, 225, 420)];
           
            [self addSubview:mainContent];
            [self mainContentLayout];
            
            UITapGestureRecognizer * tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGRHandle:)];
            tapGR.numberOfTapsRequired = 1;
            [mainContent addGestureRecognizer:tapGR];
            
            
            
        }
      
        isHidden = YES;
    }
    
    return self;
}

-(void)mainContentLayout{

    {
        UILabel * remoteLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 196, 60)];
        remoteLabel.text = @"遥控器";
        remoteLabel.font = [UIFont fontWithName:@"FZLTCXHJW--GB1-0" size:18];
        [mainContent addSubview:remoteLabel];
        
        UIImageView * remoteIcon = [[UIImageView alloc]initWithFrame:CGRectMake(-16, 25, 9, 9)];
        remoteIcon.image = [UIImage imageNamed:@"icon_remote.png"];
        [mainContent addSubview:remoteIcon];
        
        NSArray * ipAddress = [[NSArray alloc]initWithObjects:@"192",@"168",@"1",@"1", nil];
        RemoteService * rs = [RemoteService sharedInstance];
        if (![rs.remoteBoxIP isEqual: @""]) {
            ipAddress = [rs.remoteBoxIP componentsSeparatedByString:@"."];
        }
        
        UITextFieldArray = [[NSMutableArray alloc]init];
        UIColor * bgcolor_textField = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_textField.png"]];
        UITextField * IPAddress_01 = [[UITextField alloc]initWithFrame:CGRectMake(0, 60, 42, 28)];
        IPAddress_01.keyboardType = UIKeyboardTypeNumberPad;
        IPAddress_01.returnKeyType = UIReturnKeyNext;
        IPAddress_01.backgroundColor = bgcolor_textField;
        IPAddress_01.textAlignment = UITextAlignmentCenter;
        IPAddress_01.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        IPAddress_01.text = ipAddress[0];
        [UITextFieldArray addObject:IPAddress_01];
        [mainContent addSubview:IPAddress_01];
        
        UITextField * IPAddress_02 = [[UITextField alloc]initWithFrame:CGRectMake(52, 60, 42, 28)];
        IPAddress_02.keyboardType = UIKeyboardTypeNumberPad;
        IPAddress_02.returnKeyType = UIReturnKeyNext;
        IPAddress_02.backgroundColor = bgcolor_textField;
        IPAddress_02.textAlignment = UITextAlignmentCenter;
        IPAddress_02.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        IPAddress_02.text = ipAddress[1];
        [UITextFieldArray addObject:IPAddress_02];
        [mainContent addSubview:IPAddress_02];
        
        UITextField * IPAddress_03 = [[UITextField alloc]initWithFrame:CGRectMake(104, 60, 42, 28)];
        IPAddress_03.keyboardType = UIKeyboardTypeNumberPad;
        IPAddress_03.returnKeyType = UIReturnKeyNext;
        IPAddress_03.backgroundColor = bgcolor_textField;
        IPAddress_03.textAlignment = UITextAlignmentCenter;
        IPAddress_03.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        IPAddress_03.text = ipAddress[2];
        [UITextFieldArray addObject:IPAddress_03];
        [mainContent addSubview:IPAddress_03];
        
        UITextField * IPAddress_04 = [[UITextField alloc]initWithFrame:CGRectMake(156, 60, 42, 28)];
        IPAddress_04.keyboardType = UIKeyboardTypeNumberPad;
        IPAddress_04.returnKeyType = UIReturnKeyDone;
        IPAddress_04.backgroundColor = bgcolor_textField;
        IPAddress_04.textAlignment = UITextAlignmentCenter;
        IPAddress_04.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        IPAddress_04.text = ipAddress[3];
        [UITextFieldArray addObject:IPAddress_04];
        [mainContent addSubview:IPAddress_04];
    }
    
    {
        UILabel * applicationLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, 196, 60)];
        applicationLabel.text = @"视频应用";
        applicationLabel.font = [UIFont fontWithName:@"FZLTCXHJW--GB1-0" size:18];
        [mainContent addSubview:applicationLabel];
        
        UIImageView * applicationIcon = [[UIImageView alloc]initWithFrame:CGRectMake(-16, 125, 9, 9)];
        applicationIcon.image = [UIImage imageNamed:@"icon_application.png"];
        [mainContent addSubview:applicationIcon];

        applicationGridView = [[XHGridView alloc] initWithFrame:CGRectMake(0, 160, 200, 230)];
        applicationGridView.backgroundColor = [UIColor colorWithRed:248/255.0f green:248/255.0f blue:248/255.0f alpha:1];
        applicationGridView.delegate = self;
        applicationGridView.dataSource = applicationMA;
        applicationGridView.cellMarginRight = 35;
        applicationGridView.cellMarginBottom = 15;
        applicationGridView.gridPaddingLeft = 20;
        applicationGridView.gridPaddingTop = 20;
        applicationGridView.colNumPerPage = 2;
        applicationGridView.rowNumPerPage = 2;
        [applicationGridView layoutPerPage];
        [mainContent addSubview:applicationGridView];

    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"boxDeviceIPOnChange"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUITextFieldValue)
                                                 name:@"boxDeviceIPOnChange"
                                               object:nil];

    
}

#pragma mark 实现XHGridView代理方法

/*
 描述 : 实现代理方法layoutGridCell，完成cell的布局
 输入 : cell的索引
 输出 : 无
 */
-(XHGridViewCell *)layoutGridCell:(NSInteger)index{
    
    XHGridViewCell * cell = [[XHGridViewCell alloc]initWithFrame:CGRectMake(0, 0, 60, 90)];
    UIView * Disney = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 90)];
    Disney.backgroundColor = [UIColor clearColor];
    UIImageView * DisneyImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    DisneyImage.image = [UIImage imageNamed:@"icon_disney.png"];
    [Disney addSubview:DisneyImage];
    UILabel * DisneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 60, 30)];
    [Disney addSubview:DisneyLabel];
    DisneyLabel.textAlignment = UITextAlignmentCenter;
    DisneyLabel.text = @"迪斯尼";
    DisneyLabel.font = [UIFont fontWithName:@"FZLTCXHJW--GB1-0" size:14];
    DisneyLabel.backgroundColor = [UIColor clearColor];
    [cell addSubview:Disney];
    return cell;
    
    
}

/*
 描述 : 手动输入IP地址点击其他空白区域后，隐藏软键盘并保存输入结果
 输入 : 
 输出 : 无
 */
-(void)tapGRHandle:(UITapGestureRecognizer *) recognizer{
    
    [self saveIPAddress];
   
}

/*
 描述 : 隐藏软键盘并保存输入结果
 输入 :
 输出 : 无
 */
-(void)saveIPAddress {

    NSMutableArray * ipAddress = [[NSMutableArray alloc]init];
    
    for (UITextField * currentTextField in UITextFieldArray) {
        [currentTextField resignFirstResponder];
        [ipAddress addObject:currentTextField.text];
        
    }
    NSString * ip = [ipAddress componentsJoinedByString:@"."];
    [RemoteService ModifyBoxIP:ip shouldUpdateUITextField:NO];
}

/*
 描述 : 实现Notification boxDeviceIPOnChange 的事件
 输入 :
 输出 : 无
 */
-(void)updateUITextFieldValue {

    NSArray * ipAddress = [[NSArray alloc]init];
    RemoteService * rs = [RemoteService sharedInstance];
    if (![rs.remoteBoxIP isEqual: @""]) {
        ipAddress = [rs.remoteBoxIP componentsSeparatedByString:@"."];
    }
    int i = 0;
    for (UITextField * currentTextField in UITextFieldArray) {
        currentTextField.text = ipAddress[i];
        i++;
    }
}


@end