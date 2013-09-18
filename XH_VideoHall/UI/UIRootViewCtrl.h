/*
 Copyright (C) 2013 BesTV All rights reserved.
 Author      : wangdan
 Create date : 2013/8/16
 Version     : 1.0
 Description :
 */

#import <UIKit/UIKit.h>
#import "UzysGridView.h"
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "UISettingView.h"
#import "UIViewCtrlLoading.h"


@interface UIRootViewCtrl : UIViewController<UITextFieldDelegate,
                                          UzysGridViewDelegate,
                                          SGFocusImageFrameDelegate,
                                          UzysGridViewDataSource>
{
    
    UIScrollView         * contentScrollView;     
    UzysGridView         * videoListGridView;
    UISettingView        * settingView;
    UITextField          * searchInput;
    SGFocusImageFrame    * sliderImgFrame;
    NSMutableArray       * videoListDataArr;    //数据源
    NSMutableArray       * sliderImgArr;        //跑马灯图片数组
    ASIHTTPRequest       * asiRequest;
    ASINetworkQueue      * asiQueue;
    UIViewCtrlLoading    * ctrlLoading;         //切换到RemoteViewCtrl时用
   

  
}

@end