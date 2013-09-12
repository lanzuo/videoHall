#import "UIAppView.h"


@implementation UIAppView

-(id)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        applicationMA = [[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4", nil];
        
        applicationGridView = [[XHGridView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        applicationGridView.delegate = self;
        applicationGridView.dataSource = applicationMA;
        applicationGridView.cellMarginRight = 35;
        applicationGridView.cellMarginBottom = 15;
        applicationGridView.gridPaddingLeft = 35;
        applicationGridView.gridPaddingTop = 35; 
        [applicationGridView layoutPerPage];
        [self addSubview:applicationGridView];
        
        {
            UILabel * topTouchArea = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
            topTouchArea.backgroundColor = [UIColor clearColor];
            topTouchArea.userInteractionEnabled = YES;
            panGR = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGRAction)];
            [topTouchArea addGestureRecognizer:panGR];
            [self addSubview:topTouchArea];
        }
       
    }
    return self;

}


#pragma mark UzysGridView delegate function

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
    DisneyLabel.font = [UIFont systemFontOfSize:14];
    [cell addSubview:Disney];    
    return cell;
    
    
}


-(void)panGRAction{

    CGRect frame = self.frame;
    CGPoint point = [panGR translationInView:self];
    if (frame.origin.y < 480 && point.y >= 0) {
        [UIView animateWithDuration:0.4 animations:^(void){
            self.frame = CGRectMake(0, 480, self.bounds.size.width, self.bounds.size.height);
        } completion:nil];
    }


}











@end