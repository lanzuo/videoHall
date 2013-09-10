//
//  UzysGridViewCell.h
//  UzysGridView
//
//  Created by Uzys on 11. 11. 7..
//  Copyright (c) 2011 Uzys. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class UzysGridView;
@class UzysGridViewCell;

#pragma -UzysGridViewCellDelegate
@protocol UzysGridViewCellDelegate<NSObject>

-(void) gridViewCell:(UzysGridViewCell *)cell touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
-(void) gridViewCell:(UzysGridViewCell *)cell touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
-(void) gridViewCell:(UzysGridViewCell *)cell touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
-(void) gridViewCell:(UzysGridViewCell *)cell touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

@end

@interface UzysGridViewCell : UIView<UIGestureRecognizerDelegate>
{
    NSInteger _index;                                   //Cell index
}

@property (nonatomic, assign) id<UzysGridViewCellDelegate> delegate;
@property (nonatomic, assign) NSInteger page; 
@property (nonatomic, assign) NSInteger index;
@property (nonatomic,assign) CGRect cellInitFrame;


@end
