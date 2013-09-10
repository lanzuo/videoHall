#import <UIKit/UIKit.h>
#import "UzysGridView.h"
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "SettingView.h"
#import "UIViewCtrlLoading.h"


@interface RootViewCtrl : UIViewController<UITextFieldDelegate,
                                          UzysGridViewDelegate,
                                          SGFocusImageFrameDelegate,
                                          UzysGridViewDataSource>{
    
    UIScrollView         * contentScrollView;     
    UzysGridView         * videoListGridView;
    SettingView          * settingView;
    UITextField          * searchInput;
    SGFocusImageFrame    * sliderImgFrame;
    NSMutableArray       * videoListDataArr;    //数据源
    NSMutableArray       * sliderImgArr;        //跑马灯图片数组
    ASIHTTPRequest       * asiRequest;
    ASINetworkQueue      * asiQueue;
    UIViewCtrlLoading    * ctrlLoading;
  
}

//-(void)loadSliderImg;
//-(void)loadContentScrollView;

@end