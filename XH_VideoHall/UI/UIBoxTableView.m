#import "UIBoxTableView.h"


@implementation UIBoxTableView

@synthesize delegate;

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        boxList = [[NSMutableArray alloc]init];
        boxScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:boxScrollView];
        
    }
    
    return self;

}

-(void)pushOneBox : (Client * )box {

  
    [boxList addObject:box];
    /*UIBoxTableViewCell * boxCell = [[UIBoxTableViewCell alloc]initWithFrame:CGRectMake(0, 70*([boxList count] - 1), 220 , 70)];
    */
    
    UIBoxTableViewCell * boxCell = [self.delegate layoutBoxCell];
    boxCell.frame = CGRectMake(0, boxCell.frame.size.height * ([boxList count] - 1), boxCell.frame.size.width, boxCell.frame.size.height);
    boxCell.ipAddress.text = box.ipAddress;
    boxCell.ipAddress.textAlignment = UITextAlignmentCenter;
    CGSize contentSize = CGSizeMake(self.frame.size.width, boxCell.frame.size.height * [boxList count]);
    [boxScrollView setContentSize:contentSize];
    
    [boxCell.btn addSubview:boxCell.ipAddress];
    boxCell.tag = [boxList count] - 1;
    [boxCell.btn addTarget:self action:@selector(cellBtnClick:) forControlEvents:UIControlEventTouchDown];
    [boxCell addSubview:boxCell.btn];
    
    [boxScrollView addSubview:boxCell];
}

-(void)cellBtnClick:(id)sender{

    UIButton * btn = (UIButton *)sender ;
    Client * box = [boxList objectAtIndex:btn.tag];
    
    if (delegate && [delegate respondsToSelector:@selector(boxCellClick:)]) {
        [delegate boxCellClick:box.ipAddress];
    }
    

}




@end