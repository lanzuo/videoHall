//
//  UzysGridViewCell.m
//  UzysGridView
//
//  Created by Uzys on 11. 11. 7..
//  Copyright (c) 2011 Uzys. All rights reserved.
//

#import "UzysGridViewCell.h"
//#import "UzysGridView.h"


@implementation UzysGridViewCell

@synthesize index=_index;
@synthesize page;
@synthesize delegate;
@synthesize cellInitFrame;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {       
        self.exclusiveTouch =YES;
    }
    return self;
}

- (void)dealloc {

    [super dealloc];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

- (void)setCellIndex:(NSNumber *)theIndex
{
    _index = [theIndex intValue];
}
- (void)setCellPage:(NSNumber *)thePage
{
    page = [thePage intValue];
}


#pragma Touch Event Handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    

    if(self.delegate && [self.delegate respondsToSelector:@selector(gridViewCell:touchesMoved:withEvent:)])
    {

        [self.delegate gridViewCell:self touchesBegan:touches withEvent:event];        
    }
	[super touchesBegan:touches withEvent:event];

    NSLog(@"TB");
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

    if(self.delegate && [self.delegate respondsToSelector:@selector(gridViewCell:touchesMoved:withEvent:)])
    {
        [self.delegate gridViewCell:self touchesMoved:touches withEvent:event];        
    }
    [super touchesMoved:touches withEvent:event];
	
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

    if(self.delegate && [self.delegate respondsToSelector:@selector(gridViewCell:touchesEnded:withEvent:)])
    {
        [self.delegate gridViewCell:self touchesEnded:touches withEvent:event];        
    }

    [super touchesEnded:touches withEvent:event];

}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(gridViewCell:touchesCancelled:withEvent:)])
    {
        [self.delegate gridViewCell:self touchesCancelled:touches withEvent:event];        
    }
}


@end
