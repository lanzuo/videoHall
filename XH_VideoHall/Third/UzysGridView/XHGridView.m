#import "XHGridView.h"
//#import "XHGridViewCell.h"

@implementation XHGridView

@synthesize dataSource;
@synthesize delegate;
@synthesize cellMarginRight;
@synthesize cellMarginBottom;
@synthesize gridPaddingLeft;
@synthesize gridPaddingTop;
@synthesize rowNumPerPage;
@synthesize colNumPerPage;


-(id)initWithFrame:(CGRect)frame{
    
    
    if (self = [super initWithFrame:frame]) {
        
        [self initVar];
        [self layout];
        
    }
    return self;


}

//initialize variables
-(void)initVar{
    
    GridFrame = self.frame;
    self.needScrollView = NO;
    self.rowNumPerPage = 3;
    self.colNumPerPage = 3;
    self.cellMarginRight = 0;
    self.cellMarginBottom = 0;
    self.gridPaddingLeft = 0;
    self.gridPaddingTop = 0;

    CurrentPage = 0;
        
}

-(void)layout{
    
    if (self.needScrollView) {
        ScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, GridFrame.size.width, GridFrame.size.height)];
        [self addSubview:ScrollView];
    }
    
    //[self layoutPerPage];


}

-(void)layoutPerPage{

    //NSInteger cellCount = [dataSource count];
    //totalPage = ceil((float)cellCount / (float)(rowNumPerPage*colNumPerPage));
  
    
    for (int i = 0; i<self.rowNumPerPage*self.colNumPerPage; i++) {
        
        XHGridViewCell * cell = [self.delegate layoutGridCell:i];
        CGSize cellSize = cell.frame.size;
        NSInteger rowIndex = i / self.colNumPerPage;
        NSInteger colIndex = i % self.colNumPerPage;
        [UIView animateWithDuration:0.2 animations:^(void){
            cell.frame = CGRectMake(colIndex * (cellSize.width + self.cellMarginRight) + self.gridPaddingLeft, rowIndex * (cellSize.height + self.cellMarginBottom ) + self.gridPaddingTop, cellSize.width, cellSize.height);
        } completion:nil];
        [self addSubview:cell];
    }
    
}














@end