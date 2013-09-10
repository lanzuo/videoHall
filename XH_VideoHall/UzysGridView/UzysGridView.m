//
//  UzysGridView.m
//  UzysGridView
//
//  Created by Uzys on 11. 11. 7..
//  Copyright (c) 2011 Uzys. All rights reserved.
//
#define COLLISIONWIDTH 80 //distance between moving cell and collision cell
#define PAGEMOVEMARGIN 70
#import "UzysGridView.h"

@interface UzysGridView (private)
- (void) InitVariable;


- (void) createLayout:(BOOL)isVariable;
- (void) LoadTotalView ;

//Cell Method;
- (void) setCurrentPageIndex:(NSUInteger)currentPageIndex;
- (void) MovePage:(NSInteger)index animated:(BOOL) animate;
- (void) cellWasSelected:(UzysGridViewCell *)cell;

- (void) CellSetPosition:(UzysGridViewCell *) cell;

- (NSInteger) CellCollisionDetection:(UzysGridViewCell *) cell;
@end

@implementation UzysGridView


@synthesize dataSource;
@synthesize delegate,delegateScrollView;
@synthesize numberOfRows;
@synthesize numberOfColumns;
@synthesize cellMargin;
@synthesize colPosX,rowPosY;

//Readonly
@synthesize scrollView= _scrollView;
@synthesize currentPageIndex=_currentPageIndex;
@synthesize numberOfPages=_numberOfPages;



-(void) InitVariable 
{
    _cellInfo = [[NSMutableArray alloc] init ];
    
}

-(void) CellSetPosition:(UzysGridViewCell *) cell
{
    NSLog(@"setposition");
    NSUInteger numCols = self.numberOfColumns;
    NSUInteger numRows = self.numberOfRows;
    NSUInteger cellsPerPage = numCols * numRows;
    
    BOOL isLandscape = UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);
    if(isLandscape)
    {
        numCols = self.numberOfRows;
        numRows = self.numberOfColumns;
        
    }
    
    CGRect gridBounds = self.scrollView.bounds;
   // CGRect cellBounds = CGRectMake(0, 0, gridBounds.size.width / (float) numCols, gridBounds.size.height / (float) numRows);
    
    
    CGRect cellBounds = CGRectMake(0, 0, 86 + 15, 105 + 30);
   


    NSUInteger setIndex = cell.index;
    NSUInteger page = (NSUInteger)((float)(setIndex)/ cellsPerPage);
    NSUInteger row = (NSUInteger)((float)(setIndex)/numCols);
    
    CGPoint origin;
    CGRect contractFrame;
    if([colPosX count] == numCols && [rowPosY count] == numRows)
    {
        

        NSNumber *rowPos = [rowPosY objectAtIndex:row];
        NSNumber *col= [colPosX objectAtIndex:(setIndex % numCols)];
        origin = CGPointMake([rowPos intValue],(page * gridBounds.size.height) + ( [col intValue])
                             );
        contractFrame = CGRectMake((NSUInteger)origin.x, (NSUInteger)origin.y, (NSUInteger)cell.cellInitFrame.size.width, (NSUInteger)cell.cellInitFrame.size.height);
        [UIView beginAnimations:@"Move" context:nil];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
        cell.frame = contractFrame;
        [UIView commitAnimations];  
    }
    else
    {
        //origin = CGPointMake((row * cellBounds.size.width),gridBounds.size.height + (page * ((setIndex) % numCols) * cellBounds.size.height) );
        //contractFrame = CGRectMake((NSUInteger)origin.x, (NSUInteger)origin.y, (NSUInteger)cellBounds.size.width, (NSUInteger)cellBounds.size.height);
        
       origin = CGPointMake((page * gridBounds.size.width) + ((setIndex % numCols) * cellBounds.size.width),
                              (row * cellBounds.size.height));
        
           contractFrame = CGRectMake((NSUInteger)origin.x, (NSUInteger)origin.y, (NSUInteger)cellBounds.size.width, (NSUInteger)cellBounds.size.height);
        [UIView beginAnimations:@"Move" context:nil];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
        cell.frame = CGRectInset(contractFrame, self.cellMargin, self.cellMargin);
        [UIView commitAnimations];  
    }



    
    
    
}
-(NSInteger) CellCollisionDetection:(UzysGridViewCell *) cell
{

    NSMutableArray *collisionCells = [[NSMutableArray alloc] init];
    UzysGridViewCell *coll;
    NSInteger retInd =-1;
    
    NSUInteger numOfCell = [dataSource numberOfCellsInGridView:self];
    for(int i=0;i<[_cellInfo count];i++)
    {
        coll=[_cellInfo objectAtIndex:i];
        
        if(![cell isEqual:coll])
        {
          //  if(CGRectIntersectsRect(coll.frame, cell.frame))  //collision detection
          //  {
                CGFloat xDist = (coll.center.x - cell.center.x); //[2]
                CGFloat yDist = (coll.center.y - cell.center.y); //[3]
                CGFloat distance = sqrt((xDist * xDist) + (yDist * yDist)); //[4]
                
                //                if(distance < cell.frame.size.width/2)
                //                    [collisionCells addObject:coll];
                if(distance < COLLISIONWIDTH)
                    [collisionCells addObject:coll];
          //  }
        }
    }
    
    if([collisionCells count]==1)
    {
        
        
        coll = [collisionCells objectAtIndex:0];
        
        if(coll.center.x < cell.center.x)
        {
            if(coll.index +1 == numOfCell )
            {
                retInd = coll.index;
            }
            else
            {
                retInd = coll.index +1;                
            }
            NSLog(@"Collide index:%d right",retInd);
        }
        else
        {
            retInd = coll.index;
            NSLog(@"Collide index:%d left",retInd);
            
        }
        
        
        
    }



    return retInd;
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createLayout:NO];        
        [self InitVariable];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame numOfRow:(NSUInteger)rows numOfColumns:(NSUInteger)columns cellMargin:(NSUInteger)cellMargins
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.numberOfRows = rows;
        self.numberOfColumns= columns;
        self.cellMargin =cellMargins;
        [self createLayout:YES];
        [self InitVariable];

    }
    return self;
}

- (void)dealloc {
    NSLog(@"dealloc uzysgridview");


    //[_scrollView release];
   // [_cellInfo release];
    //[colPosX release];
    //[rowPosY release];
   // [super dealloc];
}


// ----------------------------------------------------------------------------------
#pragma - Layout/Draw

- (void) createLayout:(BOOL)isVariable
{

    _currentPageIndex = 0;
    
    
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight; 
    self.contentMode = UIViewContentModeRedraw;
    self.backgroundColor = [UIColor clearColor];

    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds] ;

     _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.alwaysBounceHorizontal = NO;
    _scrollView.alwaysBounceVertical = YES;
    _scrollView.showsVerticalScrollIndicator = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delaysContentTouches =YES;
    _scrollView.scrollsToTop = NO;
    _scrollView.multipleTouchEnabled = NO;
    //[self addSubview:_scrollView];
    
  //  [self reloadData];


    
}
- (void)layoutSubviews 
{
    [super layoutSubviews];

}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{

    [self LoadTotalView];

}

- (void)reloadData
{
    [self setNeedsDisplay]; //called drawRect:(CGRect)rect
    [self setNeedsLayout];
}

- (void) LoadTotalView {
    
    if(self.dataSource && self.numberOfRows > 0 && self.numberOfColumns >0)
    {
        NSUInteger numCols = self.numberOfColumns;
        [_cellInfo removeAllObjects];
        
        CGRect gridBounds = self.scrollView.bounds;
        
        
        CGRect cellBounds = CGRectMake(0, 0, 86 + 15, 105 + 40);
        
        CGSize contentSize = CGSizeMake(gridBounds.size.width, self.numberOfPages * 145 * 3);
        [_scrollView setContentSize:contentSize];
        
        
        for(UIView *v in self.scrollView.subviews) 
        {
            [v removeFromSuperview];
        }
        
        for(NSUInteger i = 0 ; i< [self.dataSource numberOfCellsInGridView:self];i++)
        {
            UzysGridViewCell *cell = [self.dataSource gridView:self cellAtIndex:i];
            NSUInteger row = ((NSUInteger)(float)i/numCols);
            CGPoint origin;
            CGRect contractFrame;
               
                origin = CGPointMake(((i % numCols) * cellBounds.size.width),
                                    row * cellBounds.size.height);
                
                contractFrame = CGRectMake((NSUInteger)origin.x, (NSUInteger)origin.y, (NSUInteger)cellBounds.size.width, (NSUInteger)cellBounds.size.height);
                cell.frame = CGRectInset(contractFrame, self.cellMargin, self.cellMargin);
            
            cell.delegate = self;
            
            [self addSubview:cell];
            
            
            [_cellInfo addObject:cell];
        }
        [self MovePage:self.currentPageIndex animated:NO];
        
    }
    
}

// ----------------------------------------------------------------------------------
#pragma - Cell/Page Control




- (void)updateCurrentPageIndex
{

    //NSUInteger curPage = round(self.scrollView.contentOffset.y / self.scrollView.frame.size.height);
    NSUInteger curPage = round((_scrollView.contentOffset.y - (145*3 -  184)) / (145*3));

     static NSUInteger prevPage =0;
 
    if(curPage != prevPage)
    {
        _currentPageIndex =curPage;
        if (delegate && [delegate respondsToSelector:@selector(gridView:changedPageIndex:)]) {
            
            [self.delegate gridView:self changedPageIndex:curPage];
        }
    }
    
    prevPage = curPage;
    
}
- (void) MovePage:(NSInteger)index animated:(BOOL) animate
{
 
    //if(index < self.numberOfPages)
    //{
  
        CGPoint move = CGPointMake(0,145 * 3 * index);
        //  _scrollView.contentOffset = move;
        //  [_scrollView setContentOffset:move animated:YES];
        
        if(animate)
        {
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{_scrollView.contentOffset = move;} completion:^(BOOL finished){
            
                if (delegate && [delegate respondsToSelector:@selector(gridView:endMovePage:)]) {
                    [delegate gridView:self endMovePage:index];
                }

            
            }];
        }
        else
        {
            _scrollView.contentOffset = move;
        }
        _currentPageIndex = index;
    //}
    //else
    //{
      //  NSLog(@"MovePage - OutOfRange !");
    //}

}


// ----------------------------------------------------------------------------------
#pragma - UzysGridView callback
- (void)cellWasSelected:(UzysGridViewCell *)cell
{
    NSLog(@"Cellwasselected");
    if (delegate && [delegate respondsToSelector:@selector(gridView:didSelectCell:atIndex:)]) {
        [delegate gridView:self didSelectCell:cell atIndex:cell.index];
    }
}

// ----------------------------------------------------------------------------------

#pragma - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updateCurrentPageIndex];
    
    if(delegateScrollView && [delegateScrollView respondsToSelector:@selector(gridView:scrollViewDidEndDecelerating:)])
        [self.delegateScrollView gridView:self scrollViewDidEndDecelerating:scrollView];
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if(delegateScrollView && [delegateScrollView respondsToSelector:@selector(gridView:scrollViewDidEndScrollingAnimation:)])
        [self.delegateScrollView gridView:self scrollViewDidEndScrollingAnimation:scrollView];
    
    [self updateCurrentPageIndex];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

     [self updateCurrentPageIndex];
    if(delegateScrollView && [delegateScrollView respondsToSelector:@selector(gridView:scrollViewDidScroll:)])
        [self.delegateScrollView gridView:self scrollViewDidScroll:scrollView];
  
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    [self updateCurrentPageIndex];
    if(delegateScrollView && [delegateScrollView respondsToSelector:@selector(gridView:scrollViewWillBeginDragging:)])
        [self.delegateScrollView gridView:self scrollViewWillBeginDragging:scrollView];
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self updateCurrentPageIndex];
    if(delegateScrollView && [delegateScrollView respondsToSelector:@selector(gridView:scrollViewWillBeginDecelerating:)])
        [self.delegateScrollView gridView:self scrollViewWillBeginDecelerating:scrollView];
}

// ----------------------------------------------------------------------------------
#pragma - Property Override

- (void)setDataSource:(id<UzysGridViewDataSource>)uDataSource  //override
{
    dataSource = uDataSource;
}



- (void)setNumberOfColumns:(NSUInteger)value
{
    numberOfColumns = value;
   // [self reloadData];
}


- (void)setNumberOfRows:(NSUInteger)value
{
    numberOfRows = value;
   // [self reloadData];
}


- (void)setCellMargin:(NSUInteger)value
{
    cellMargin = value;
   // [self reloadData];
}

-(void) colPosX:(NSMutableArray *)value
{
    //colPosX = [value retain];
   // [self reloadData];
    
}

- (void) setCurrentPageIndex:(NSUInteger)currentPageIndex
{
    if(currentPageIndex <  self.numberOfPages)
        _currentPageIndex = currentPageIndex;
    else
        _currentPageIndex = self.numberOfPages -1 ;
    
    if(self.numberOfPages == 0)
        _currentPageIndex = 0;
    
}

- (NSUInteger)numberOfPages
{
    NSUInteger numberOfCells = [self.dataSource numberOfCellsInGridView:self];
    
    NSUInteger cellsPerPage = self.numberOfColumns * self.numberOfRows;
    return (NSUInteger)(ceil((float)numberOfCells / (float)cellsPerPage));
}


#pragma -mark UzysGridViewCell Delegate

-(void) gridViewCell:(UzysGridViewCell *)cell touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //_touchLocation = [[touches anyObject] locationInView:_scrollView];
    
    
    {
        if([[touches anyObject] tapCount] == 1)
        {
            if (delegate && [delegate respondsToSelector:@selector(gridView:TouchUpInside:)]) {
                [delegate gridView:self TouchUpInside:cell];
            }
        }

    }
}
-(void) gridViewCell:(UzysGridViewCell *)cell touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
   // NSLog(@"item clicked....");
}

-(void) gridViewCell:(UzysGridViewCell *)cell touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{

    self.scrollView.scrollEnabled = YES;

    
    
        [UIView animateWithDuration:0.1
                              delay:0 
                            options:UIViewAnimationOptionCurveEaseIn 
                         animations:^{
                             
							 cell.transform = CGAffineTransformIdentity;
							 cell.alpha = 1;
                             
                             
                         }
                         completion:nil];

        SEL singleTapSelector = @selector(cellWasSelected:);
        //    SEL doubleTapSelector = @selector(cellWasDoubleTapped:);
        
        if (self) {
            UITouch *touch = [touches anyObject];
            
            switch ([touch tapCount]) 
            {
                case 0: //
                {
                    CGPoint curPos = [touch locationInView:self];
                    NSLog(@"CELL Frame:%@",NSStringFromCGRect(cell.frame));
                    if(CGRectContainsPoint(cell.frame, curPos))
                    {
                        //select
                        if (delegate && [delegate respondsToSelector:@selector(gridView:TouchUpOoutside:)]) {
                            [delegate gridView:self TouchUpOoutside:cell];
                        }
                        
                        [self performSelector:@selector(cellWasSelected:) withObject:cell];
                    }
                    else
                    {
                        if (delegate && [delegate respondsToSelector:@selector(gridView:TouchCanceled:)]) {
                            [delegate gridView:self TouchCanceled:cell];
                        }
                    }

                }
                    break;
                case 1:
                    if (delegate && [delegate respondsToSelector:@selector(gridView:TouchUpOoutside:)]) {
                        [delegate gridView:self TouchUpOoutside:cell];
                    }
                    [self performSelector:singleTapSelector withObject:cell];
                    break; 
                default:
                    break;
            }
        

    }
    
    NSLog(@"TE");
}

-(void) gridViewCell:(UzysGridViewCell *)cell touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_movePagesTimer invalidate];
    _movePagesTimer = nil;
    
        if (delegate && [delegate respondsToSelector:@selector(gridView:TouchCanceled:)]) {
            [delegate gridView:self TouchCanceled:cell];
        }
    
}


-(void) gridViewCell:(UzysGridViewCell *)cell handleLongPress:(NSUInteger)index
{
    //self.editable =YES;
}
@end
