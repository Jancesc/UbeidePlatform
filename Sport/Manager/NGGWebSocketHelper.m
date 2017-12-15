//
//  NGGWebSocketHelper.m
//  Sport
//
//  Created by Jan on 05/12/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGWebSocketHelper.h"

#define NGGHeartbeatInterval 5
#define NGGMaxHeartbeatCount 3
#define NGGWebSocketURL @"ws://wx7.bigh5.com:9502"

@interface NGGWebSocketHelper()<SRWebSocketDelegate> {
    
    int _heartHeartMissCount;
    NSTimer *_heartBeatTimer;
    NSTimeInterval _reConnectTime;
}

@property (nonatomic,strong) SRWebSocket *socket;

@end
@implementation NGGWebSocketHelper

+ (NGGWebSocketHelper *) shareHelper {

    static NGGWebSocketHelper *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        
        instance = [[NGGWebSocketHelper alloc] init];
        instance.urlString = NGGWebSocketURL;
    });
    
    return instance;
}

//开启连接
- (void)webSocketOpen {
  
    if (_socket) {
       
        return;
    }
    _socket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]]];
    _socket.delegate = self;   //SRWebSocketDelegate 协议
    [_socket open];     //开始连接
}

//关闭连接
- (void)webSocketClose {
  
    if (_socket){
        
        [_socket close];
        _socket = nil;
        
        if (_delegate && [_delegate respondsToSelector:@selector(closeSuccess)]) {
            
            [_delegate closeSuccess];
        }
    }
    //断开连接时销毁心跳
    [self destoryHeartBeat];
}

#pragma mark - socket delegate
- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    
    NSLog(@"连接成功，可以与服务器交流了,同时需要开启心跳");
    //每次正常连接的时候清零重连时间
    _reConnectTime = 0;
    //开启心跳 心跳是发送pong的消息 我这里根据后台的要求发送data给后台
    [self initHeartBeat];

    if (_delegate && [_delegate respondsToSelector:@selector(openSuccess)]) {
        
        [_delegate openSuccess];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
  
    _socket = nil;
    //连接失败就重连
    [self reConnect];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    
    NSLog(@"被关闭连接，code:%ld,reason:%@,wasClean:%d",code,reason,wasClean);
    //断开连接 同时销毁心跳
    [self webSocketClose];
}
          
/*
 该函数是接收服务器发送的pong消息，其中最后一个是接受pong消息的，
 在这里就要提一下心跳包，一般情况下建立长连接都会建立一个心跳包，
 用于每隔一段时间通知一次服务端，客户端还是在线，这个心跳包其实就是一个ping消息，
 我的理解就是建立一个定时器，每隔十秒或者十五秒向服务端发送一个ping消息，这个消息可是是空的
 */
-(void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload{
              
    _heartHeartMissCount = 0;
    NSString *reply = [[NSString alloc] initWithData:pongPayload encoding:NSUTF8StringEncoding];
//    NSLog(@"reply===%@",reply);
}
          
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message  {
    
    //收到服务器发过来的数据 这里的数据可以和后台约定一个格式 我约定的就是一个字符串 收到以后发送通知到外层 根据类型 实现不同的操作
    NSLog(@"接收到数据");
    if (_delegate && [_delegate respondsToSelector:@selector(didReceiveData:)]) {
        
        [_delegate didReceiveData:message];
    }
}
          
#pragma mark - methods

//重连机制
- (void)reConnect {
    
    [self webSocketClose];
    //超过一分钟就不再重连 所以只会重连5次 2^5 = 64
    if (_reConnectTime > 64) {
        
        if (_delegate && [_delegate respondsToSelector:@selector(connectedFailed)]) {
            
            [_delegate connectedFailed];
        }
        return;
    }
    NSLog(@"连接失败，这里可以实现掉线自动重连，要注意以下几点");
    NSLog(@"1.判断当前网络环境，如果断网了就不要连了，等待网络到来，在发起重连");
    NSLog(@"2.判断调用层是否需要连接，例如用户都没在聊天界面，连接上去浪费流量");
    NSLog(@"3.连接次数限制，如果连接失败了，重试10次左右就可以了，不然就死循环了。");
    AFNetworkReachabilityStatus status = [[NGGHTTPClient defaultClient] currentNetworkStatus];
    if (status == AFNetworkReachabilityStatusNotReachable) {
        NSLog(@"确实是网络无连接");
      
        return;
    }
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_reConnectTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.socket = nil;
        [self webSocketOpen];
        NSLog(@"重连");
    });
    //重连时间2的指数级增长
    if (_reConnectTime == 0) {
        
        _reConnectTime = 2;
    }else {
        
        _reConnectTime *= 2;
    }
}
          
//初始化心跳
- (void)initHeartBeat {

    [self destoryHeartBeat];
    _heartHeartMissCount = 0;
    _heartBeatTimer = [NSTimer scheduledTimerWithTimeInterval:NGGHeartbeatInterval target:self selector:@selector(sendHeartBeat) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop]addTimer:_heartBeatTimer forMode:NSRunLoopCommonModes];
}

- (void)sendHeartBeat {
    
    _heartHeartMissCount++;
    if (_heartHeartMissCount > NGGMaxHeartbeatCount) {
        
        NSLog(@"心跳无响应了,重连");
        [self reConnect];
        return;
    }
//    NSLog(@"heart");
    //和服务端约定好发送什么作为心跳标识，尽可能的减小心跳包大小
    [self ping];
}

//取消心跳
- (void)destoryHeartBeat {
    
    if (_heartBeatTimer) {
        
        [_heartBeatTimer invalidate];
        _heartBeatTimer = nil;
    }
}

//pingPong机制
- (void)ping {
    
    [_socket sendPing:nil error:nil];
}

- (SRReadyState)socketStatus {
    
    if (_socket) {
        
        return _socket.readyState;
    } else {
        
        return SR_CLOSED;
    }
}
#define WeakSelf(ws) __weak __typeof(&*self)weakSelf = self
- (void)sendData:(id)data {
    
    if (_socket && _socket.readyState == SR_OPEN) {
        
        NSError *error = nil;
        [_socket sendData:data error:&error];
    } else if(_socket.readyState == SR_CONNECTING) {
        
        
        NSLog(@"正在连接中，重连后其他方法会去自动同步数据");
        // 每隔2秒检测一次 socket.readyState 状态，检测 10 次左右
        // 只要有一次状态是 SR_OPEN 的就调用 [ws.socket send:data] 发送数据
        // 如果 10 次都还是没连上的，那这个发送请求就丢失了，这种情况是服务器的问题了，小概率的
        [self reConnect];
    } else {
        
        NSLog(@"没网络，发送失败，一旦断网 socket 会被我设置 nil 的");
    }
}
          
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
 
@end
