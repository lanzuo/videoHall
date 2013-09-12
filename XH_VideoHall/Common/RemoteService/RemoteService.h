/*
 文件 ：RemoteService.h
 创建 ： wangdan 
 时间 ： 2013/7/28
 描述 ： 定义摇控器，实现盒子的扫描、连接、发送命令逻辑
 修改 ： 
        1、
        2、

 */

#import <UIKit/UIKit.h>
#import "GCDAsyncUdpSocket.h"
#import "AsyncSocket.h"

enum remoteStatus {
    
    unconnected = 0,
    connected   = 1,
    connecting  = 2,
    scanning    = 3
    
};

@interface RemoteService : NSObject
{

    NSString          * RemoteBoxIP;      //绑定的盒子的IP地址 
    NSMutableArray    * RemoteBoxIPList;  //扫描到的盒子的IP地址数组
    AsyncSocket       * TCPSocket;
    GCDAsyncUdpSocket * UDPSocket;
    enum remoteStatus   Status;
    NSInteger           UDPPort;
    NSInteger           TCPPort;
    
}

@property (nonatomic,retain) NSString          * remoteBoxIP;
@property (nonatomic,retain) NSMutableArray    * remoteBoxIPList;
@property (nonatomic,assign) enum remoteStatus   status; 

-(void) scanWithUDP;
-(void) connectWithTCP;
-(void) sendKeyValue:(int) theKeyCode action:(int) theAction eventKey:(int) theEventKey;
-(void) sendPlayValue:(NSString * )playUri;

+(RemoteService *)sharedInstance;
+(void)ModifyBoxIP:(NSString *)ip shouldUpdateUITextField:(BOOL)should;
//-(void) connectWithTCP:(NSString *)ip;


@end
