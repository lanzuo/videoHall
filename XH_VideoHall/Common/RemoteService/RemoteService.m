
#import "RemoteService.h"
#import "StringUtil.h"
#import "IPAdress.h"
#import "Client.h"
#import "unistd.h"
#import "VHAppDelegate.h"
#define _UDPPort_ 7001
#define _TCPPort_ 7002

@implementation RemoteService
@synthesize remoteBoxIP     = RemoteBoxIP;
@synthesize remoteBoxIPList = RemoteBoxIPList;
@synthesize status          = Status;

NSString *const UDP_CLIENT_SCAN		= @"amlogic-client-scan";
NSString *const UDP_SERVER_IDLE 	= @"amlogic-server-idle";
NSString *const UDP_SERVER_USED     = @"amlogic-server-used";
NSString *const UDP_REQUEST_CONNECT	= @"amlogic-client-request-connect";
NSString *const UDP_REQ_CONFIRM		= @"amlogic-client-request-connect-yes?";
NSString *const UDP_REQ_OK			= @"amlogic-client-request-ok";
NSString *const UDP_NO_CONNECT		= @"amlogic-client-no-connect";
NSString *const UDP_SERVER_LISTEN 	= @"amlogic-server-listen";

static RemoteService * sharedInstance = nil;

- (id)init
{
    Status = unconnected;
    RemoteBoxIPList = [[NSMutableArray alloc]init];
        
    UDPPort = _UDPPort_;
    TCPPort = _TCPPort_;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    RemoteBoxIP = [prefs objectForKey:@"LastBoxIP"];
    if ([RemoteBoxIP intValue] == 0) {
        RemoteBoxIP = @"...";
    }
    UDPSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self
                                              delegateQueue:dispatch_get_main_queue()];
    
    
    
	NSError * error = nil;	
	if (![UDPSocket bindToPort:0 error:&error])
	{
        NSLog(@"%@",error);
        @throw error;
		return self;
	}
	if (![UDPSocket beginReceiving:&error])
	{
        NSLog(@"%@",error);
        @throw error;
		return self;
	}
    return self;
}

/*
 描述 : 使用UDP协议扫描同一网段的盒子
 输入 : 无
 输出 : 无
 */
-(void) scanWithUDP
{
    //IsScanning = true;
    Status = scanning;
    [RemoteBoxIPList removeAllObjects];
    
    //获取手机的IP地址
    InitAddresses();
    GetIPAddresses();
    NSString * phoneIP = [[StringUtil getString:(ip_names[1])] copy];
    
    //TODO : 需要判断手机是否入网，检查phoneIP是否为空
    
    NSArray  * arrIP = [phoneIP componentsSeparatedByString:@"."];
    NSString * ipPre = [NSString stringWithFormat:@"%@.%@.%@",
                                                  [arrIP objectAtIndex:0],
                                                  [arrIP objectAtIndex:1],
                                                  [arrIP objectAtIndex:2]];
    
    NSData * data = [[UDP_CLIENT_SCAN dataUsingEncoding:NSUTF8StringEncoding] copy];
    for (int i = 2; i <= 255; i++)
    {
        NSString * ip = [NSString stringWithFormat:@"%@.%d",ipPre,i];
        [UDPSocket sendData:data toHost:ip port:_UDPPort_ withTimeout:1 tag:0];
        usleep(10000);
    }
    
    [NSTimer scheduledTimerWithTimeInterval: 10.0
                                     target: self
                                   selector: @selector(scanTimeOutHandle:)
                                   userInfo: nil
                                    repeats: NO];

}

/*
 描述 : 扫描结束后事件处理
 输入 : 无
 输出 : 无
 */
-(void)scanTimeOutHandle:(NSTimer * )timer
{
    NSString * boxCount = [NSString stringWithFormat:@"%d",[RemoteBoxIPList count]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"scanBoxCompletion" object:boxCount];
}


/*
 描述 : 使用TCP协议将手机和盒子进行连接
 输入 : 无
 输出 : 无
 */
-(void) connectWithTCP
{
    
    if (Status != connected)
    {
        if ([RemoteBoxIP intValue] == 0) //如果IP为空
        {
            [self scanWithUDP];
        }
        else
        {
            Status = connecting;
            TCPSocket = [[AsyncSocket alloc]initWithDelegate:self];
            NSError * err;
            if (![TCPSocket connectToHost:RemoteBoxIP onPort: _TCPPort_ error: &err])
            {
                NSLog(@"connect error: %@", err);
            }
            [TCPSocket setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
        }
    }
    
   
}

/*
 描述 : 使用TCP协议将手机和指定IP地址的盒子进行连接
 输入 : 指定盒子的IP地址
 输出 : 无
 */
/*
-(void) connectWithTCP:(NSString *)ip {
    
    ConnectOK = NO;
    Status = 3;
    TCPSocket = [[AsyncSocket alloc]initWithDelegate:self];
    NSError * err;
    if (![TCPSocket connectToHost: ip onPort: _TCPPort_ error: &err])
    {
        NSLog(@"connect error: %@", err);
    }
  
}
*/

/*
 描述 : 使用UDP协议连接默认盒子
 输入 : 无
 输出 : 无
 */
-(void)connectWithUDP
{
    if ([RemoteBoxIP intValue] != 0)//如果IP不为空
    { 
        NSData *data = [[UDP_REQUEST_CONNECT dataUsingEncoding:NSUTF8StringEncoding] copy];
        [UDPSocket sendData:data toHost:RemoteBoxIP port:_UDPPort_ withTimeout:1 tag:0];
    }
    
}

/*
 描述 : 使用UDP协议连接指定IP地址的盒子
 输入 : 无
 输出 : 无
 */
-(void) connectWithUDP:(NSString *)host
{
    if ([host intValue] != 0)//如果IP不为空
    { 
        NSData *data = [[UDP_REQUEST_CONNECT dataUsingEncoding:NSUTF8StringEncoding] copy];
        [UDPSocket sendData:data toHost:host port:_UDPPort_ withTimeout:1 tag:0];
    }
}

#pragma mark 实现UDP代理方法

/*
 描述 : GCDAsyncUdpSocket代理方法，实现udpSocket连接失败后的逻辑
 输入 : GCDAsyncUdpSocket实例，错误信息
 输出 : 无
 */
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError *)error
{
    NSLog(@"udpSocket connect error: %@", error);
}

/*
 描述 : GCDAsyncUdpSocket代理方法，实现udpSocket连接后的逻辑
 输入 : GCDAsyncUdpSocket实例，连接的IP地址
 输出 : 无
 */
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address
{
    NSString *msg = [[NSString alloc] initWithData:address encoding:NSUTF8StringEncoding];
    NSLog(@"connect ip address is :%@",msg);
}

/*  
 描述 : GCDAsyncUdpSocket代理方法，实现（接收到手机发送的UDP连接指令表示能建立连接的）盒子返回信息后的逻辑
 输入 : GCDAsyncUdpSocket实例，盒子返回的数据，盒子的IP地址,filterContext
 输出 : 无
 */
- (void)udpSocket:(GCDAsyncUdpSocket *)sock
   didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(id)filterContext
{    
    Byte * byteArr = (Byte*)[address bytes];
    NSString *  ip = [[NSString alloc] initWithFormat:@"%d.%d.%d.%d",
                                                      (int)byteArr[4],
                                                      (int)byteArr[5],
                                                      (int)byteArr[6],
                                                      (int)byteArr[7]];
    //NSLog(@"udp socket receive data from  : %@",ip);
    
    if(Status == scanning)
    {
        
        Byte *byteData = (Byte*)[data bytes];
        int tempWidth  = (int)byteData[0]*256+(int)byteData[1];
        int tempHeight = (int)byteData[2]*256+(int)byteData[3];
        int tempIsUsed = (int)byteData[4];
        /*bool flag = false;
        for(Client *tempClient in RemoteBoxIPList)
        {
            if([tempClient.ipAddress isEqualToString:ip])
            {
                flag = true;
                break;
            }
        }*/
        //if(!flag){
        Client * oneClient = [[Client alloc]initWithWidth:tempWidth andHeight:tempHeight andIsUsed:tempIsUsed andIpAddress:ip];
        [RemoteBoxIPList addObject:oneClient];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ifScanOneBox" object:oneClient];        
        //}
        
    }
    else
    {
        NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if([UDP_REQ_CONFIRM caseInsensitiveCompare:msg] == NSOrderedSame)
        {
            NSData *data = [[UDP_REQ_OK dataUsingEncoding:NSUTF8StringEncoding] copy];
            [UDPSocket sendData:data toHost:ip port:_UDPPort_ withTimeout:1 tag:0];
        }
        else if([UDP_SERVER_LISTEN caseInsensitiveCompare:msg] == NSOrderedSame)
        {
            [RemoteService ModifyBoxIP:ip shouldUpdateUITextField:YES];

        }
    }
}




#pragma mark AsyncSocket代理方法
/*
 描述 : AsyncSocket代理方法，实现tcpSocket连接成功后的逻辑
 输入 : AsyncSocket实例，连接的主机名，连接的主机端口
 输出 : 无
 */
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    Status = connected;
    [RemoteService ModifyBoxIP:host shouldUpdateUITextField:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getTcpState" object:nil];
    [TCPSocket readDataWithTimeout:-1 tag:0];
}


- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    [TCPSocket readDataWithTimeout:-1 tag:0];
}

/*
 描述 : AsyncSocket代理方法，实现tcpSocket断开连接后的逻辑
 输入 : AsyncSocket实例
 输出 : 无
 */
- (void)onSocketDidDisconnect:(AsyncSocket *)sock {
    NSLog(@"disconnect");
    Status = unconnected;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getTcpState" object:nil];
    [TCPSocket release];
}

/*
 描述 : AsyncSocket代理方法，实现tcpSocket将要断开连接后的逻辑
 输入 : AsyncSocket实例，错误信息
 输出 : 无
 */
-(void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err{
    NSLog(@"udpSocket connect error: %@", err);
}

- (void)dealloc
{
    //[TCPSocket release];
    [super dealloc];
}

/*
 描述 : 发送TCP命令
 输入 : 命令字节、命令字节长度
 输出 : 无
 */
-(void) tcpSendCmd:(Byte*) theByte cmdLength:(int) theLength
{
    theByte[0] = (Byte)((theLength>>24)&0xff);
    theByte[1] = (Byte)((theLength>>16)&0xff);
    theByte[2] = (Byte)((theLength>>8)&0xff);
    theByte[3] = (Byte)(theLength&0xff);
    NSData* strdata = [[NSData alloc] initWithBytes:theByte length:theLength+4];
    [TCPSocket writeData:strdata withTimeout:-1 tag:0];          //-1表示长连接
}


/*
 描述 : 发送按键指令，响应摇控器按键指令
 输入 : 摇控器按键键值，action和eventKey应该是协议约定值
 输出 : 无
 */
-(void) sendKeyValue:(int) theKeyCode action:(int) theAction eventKey:(int) theEventKey
{
    Byte sendByte[8];
    sendByte[4] =(Byte)theEventKey;
    sendByte[5] =(Byte)theAction;
    sendByte[6] =(Byte)theKeyCode;
    sendByte[7] =(Byte)0;
    [self tcpSendCmd:sendByte cmdLength:4];
}

/*
 描述 : 发送播放指令，响应UIDetailView的播放按钮事件
 输入 : 节目的Uri
 输出 : 无
 */
-(void) sendPlayValue:(NSString * )playUri
{
    NSString * epiUri = [NSString stringWithFormat:@"URI=%@%@",playUri,@"|1:play"] ;
    NSData * playData = [epiUri dataUsingEncoding: NSUTF8StringEncoding];
    Byte sendByte[[playData length]+6];
    sendByte[4] = (Byte)8;
    sendByte[5] = (Byte)5;
    memcpy(&sendByte[6],[playData bytes],[playData length]);
    [self tcpSendCmd:sendByte cmdLength:[playData length]+2];
}




/*
 描述 : 修改绑定的盒子的IP地址，当通过设置手动更新／重新扫描更改盒子后，需要通知settingView更新UITextField的值
 输入 : IP地址
 输出 : 无
 */
+(void)ModifyBoxIP:(NSString *)ip shouldUpdateUITextField:(BOOL)should
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:ip forKey:@"LastBoxIP"];
    [prefs synchronize];
    if (should) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"boxDeviceIPOnChange" object:ip];
    }
}

+(RemoteService *)sharedInstance
{
    @synchronized(self) {
        if (sharedInstance == nil)
            sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}

@end
