#import <UIKit/UIKit.h>
#import "applicationView.h"
#import "RemoteService.h"
#import "UIBoxTableView.h"
#import "UIBoxTableViewCell.h"


#define RC_KEYCODE_HOME					0
#define RC_KEYCODE_MENU					1
#define RC_KEYCODE_BACK					2
#define RC_KEYCODE_VOLUME_UP			3
#define RC_KEYCODE_VOLUME_DOWN		    4
#define RC_KEYCODE_SEARCH			    5
#define RC_KEYCODE_MUTE					6
#define RC_KEYCODE_UP					7
#define RC_KEYCODE_DOWN					8
#define RC_KEYCODE_LEFT					9
#define RC_KEYCODE_RIGHT			    10
#define RC_KEYCODE_CENTER			    11   //ok key
#define RC_KEYCODE_POWER			    12
#define RC_KEYCODE_CAMERA			    13
#define RC_KEYCODE_CLEAR			    14
#define RC_KEYCODE_SOFT_LEFT			15
#define RC_KEYCODE_SOFT_RIGHT			16
#define RC_KEYCODE_CALL				    17
#define RC_KEYCODE_ENDCALL				18
#define RC_KEYCODE_0					19
#define RC_KEYCODE_1					20
#define RC_KEYCODE_2					21
#define RC_KEYCODE_3					22
#define RC_KEYCODE_4					23
#define RC_KEYCODE_5					24
#define RC_KEYCODE_6					25
#define RC_KEYCODE_7					26
#define RC_KEYCODE_8					27
#define RC_KEYCODE_9					28
#define RC_KEYCODE_STAR					29
#define RC_KEYCODE_POUND				30
#define RC_KEYCODE_A					31
#define RC_KEYCODE_B                	32
#define RC_KEYCODE_C                	33
#define RC_KEYCODE_D                	34
#define RC_KEYCODE_E                	35
#define RC_KEYCODE_F                	36
#define RC_KEYCODE_G                	37
#define RC_KEYCODE_H                	38
#define RC_KEYCODE_I                	39
#define RC_KEYCODE_J                	40
#define RC_KEYCODE_K                	41
#define RC_KEYCODE_L                	42
#define RC_KEYCODE_M                	43
#define RC_KEYCODE_N                	44
#define RC_KEYCODE_O                	45
#define RC_KEYCODE_P                	46
#define RC_KEYCODE_Q                	47
#define RC_KEYCODE_R                	48
#define RC_KEYCODE_S                	49
#define RC_KEYCODE_T                	50
#define RC_KEYCODE_U                	51
#define RC_KEYCODE_V                	52
#define RC_KEYCODE_W                	53
#define RC_KEYCODE_X                	54
#define RC_KEYCODE_Y                	55
#define RC_KEYCODE_Z               		56
#define RC_KEYCODE_COMMA            	57
#define RC_KEYCODE_PERIOD           	58
#define RC_KEYCODE_ALT_LEFT           	59
#define RC_KEYCODE_ALT_RIGHT        	60
#define RC_KEYCODE_SHIFT_LEFT       	61
#define RC_KEYCODE_SHIFT_RIGHT      	62
#define RC_KEYCODE_TAB              	63
#define RC_KEYCODE_SPACE            	64
#define RC_KEYCODE_SYM              	65
#define RC_KEYCODE_EXPLORER         	66
#define RC_KEYCODE_ENVELOPE         	67
#define RC_KEYCODE_ENTER            	68
#define RC_KEYCODE_DEL              	69
#define RC_KEYCODE_GRAVE            	70
#define RC_KEYCODE_MINUS            	71
#define RC_KEYCODE_EQUALS           	72
#define RC_KEYCODE_LEFT_BRACKET     	73
#define RC_KEYCODE_RIGHT_BRACKET    	74
#define RC_KEYCODE_BACKSLASH        	75
#define RC_KEYCODE_SEMICOLON        	76
#define RC_KEYCODE_APOSTROPHE       	77
#define RC_KEYCODE_SLASH            	78
#define RC_KEYCODE_AT               	79
#define RC_KEYCODE_NUM              	80
#define RC_KEYCODE_HEADSETHOOK      	81
#define RC_KEYCODE_FOCUS            	82  // *Camera* focus
#define RC_KEYCODE_PLUS             	83
#define RC_KEYCODE_NOTIFICATION     	84
#define RC_KEYCODE_MEDIA_PLAY_PAUSE		85
#define RC_KEYCODE_MEDIA_STOP       	86
#define RC_KEYCODE_MEDIA_NEXT       	87
#define RC_KEYCODE_MEDIA_PREVIOUS   	88
#define RC_KEYCODE_MEDIA_REWIND     	89
#define RC_KEYCODE_MEDIA_FAST_FORWARD   90
#define RC_KEYCODE_UNKNOWN				91

#define EVENT_ACK       	0
#define EVENT_KEY       	1
#define EVENT_TOUCH      	2
#define EVENT_TRACKBALL     3
#define EVENT_SENSOR        4
#define EVENT_UI_STATE		5
#define EVENT_GET_SCREEN   	6
#define EVENT_KEY_MODE      7
#define EVENT_SERVICE   	8

@interface UIRemoteViewCtrl : UIViewController<UIBoxTableViewDelegate,UIGestureRecognizerDelegate>{

    UIButton                     * btn_quit;
    UIView                       * remoteCtrlWrapper;    
    applicationView              * applicationPanel;
    UITableView                  * devicesTblView;    
    RemoteService                * rs;
    UILabel                      * waitLabel ;
    UIActivityIndicatorView      * waitIdv;
    UIBoxTableView               * boxView;
    

    
}

@end