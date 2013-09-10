#import <UIKit/UIKit.h>
#import "Client.h"
#import "UIBoxTableViewCell.h"


@protocol UIBoxTableViewDelegate <NSObject>

-(UIBoxTableViewCell * )layoutBoxCell;

-(void)boxCellClick:(NSString * )ipAddress;

@end

@interface UIBoxTableView : UIView
{
    
    UIScrollView * boxScrollView;
    NSMutableArray * boxList;
    
}

@property(nonatomic,retain) id<UIBoxTableViewDelegate>delegate;


-(void)pushOneBox : (Client *) box;
@end