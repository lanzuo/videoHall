#import <UIKit/UIKit.h>
#import "XHGridViewCell.h"

@protocol XHGridViewDelegate <NSObject>

-(XHGridViewCell *) layoutGridCell:(NSInteger)index;


@end

@interface XHGridView : UIView{

    CGRect GridFrame;
    UIScrollView * ScrollView;    
    NSInteger CurrentPage;
    NSInteger TotalPage;
    
   
    
    
}


@property(nonatomic,assign) NSMutableArray * dataSource;
@property(nonatomic,assign) NSInteger rowNumPerPage;
@property(nonatomic,assign) NSInteger colNumPerPage;
@property(nonatomic,assign) BOOL needScrollView;
@property(nonatomic,assign) id<XHGridViewDelegate> delegate;
@property(nonatomic,assign) NSInteger cellMarginRight;
@property(nonatomic,assign) NSInteger cellMarginBottom;
@property(nonatomic,assign) NSInteger gridPaddingLeft;
@property(nonatomic,assign) NSInteger gridPaddingTop;

-(void)layoutPerPage;

@end