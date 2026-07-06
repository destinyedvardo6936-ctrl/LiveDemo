//
//  LCSocketManager.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/17.
//

#import <SocketIO/SocketIO-Swift.h>
#import "LCSocketManager.h"
#import "LCLanguageManager.h"
@interface LCSocketManager ()
@property (nonatomic, strong) SocketManager *socketManager;
@property (nonatomic, strong) SocketIOClient *socketClient;
@end
@implementation LCSocketManager
+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    static LCSocketManager *manager;

    dispatch_once(&onceToken, ^{
        manager = [[LCSocketManager alloc]init];
    });
    return manager;
}

- (void)connetToSever:(NSString *)urlStr
             delegate:(id<LCSocketManagerDelegate>)delegate
               roomId:(NSString *)roomId
               stream:(NSString *)stream {
    /**
       //            log 是否打印日志
       //            forceNew      这个参数设为NO从后台恢复到前台时总是重连，暂不清楚原因
       //            forcePolling  是否强制使用轮询
       //            reconnectAttempts 重连次数，-1表示一直重连
       //            reconnectWait 重连间隔时间
       //            connectParams 参数
       //            forceWebsockets 是否强制使用websocket, 解释The reason it uses polling first is because some firewalls/proxies block websockets. So polling lets socket.io work behind those.
       //
       //       **/
    //
    if(self.socketClient){
        [self disconnect];
    }
    
    NSURL *url = [[NSURL alloc] initWithString:urlStr];
//    SSLSecurity *SSLSecu = [[SSLSecurity alloc]initWithUsePublicKeys:YES];

    
    _delegate = delegate;
    
    self.socketManager = [[SocketManager alloc]initWithSocketURL:url config:@{ @"log": @NO, /*@"selfSigned": @YES, @"securty": SSLSecu,*/ /*@"forceNew": @YES, @"forcePolling": @NO, @"reconnectAttempts": @(-1), @"reconnectWait": @1, @"forceWebsockets": @YES, */@"compress": @YES}];
    SocketIOClient *socket = self.socketManager.defaultSocket;
    self.socketClient = socket;
    
    WS(weakSelf)
    [self.socketClient connect];
    [self.socketClient on:@"connect" callback:^(NSArray * _Nonnull arr, SocketAckEmitter * _Nonnull ack) {
        LCLog(@"socket.io connect -- %@",arr);
        if(roomId.length){
            NSArray *cur = @[@{@"username":[LCUserInfoManager shareManager].userInfo.user_nicename,
                               @"uid":[LCUserInfoManager shareManager].userInfo.ID,
                               @"token":[LCUserInfoManager shareManager].userInfo.token,
                               @"roomnum":roomId,
                               @"stream":stream,
                               @"lang":[[LCLanguageManager shareManager] getLanguageEncode],
                               }];
            [weakSelf.socketClient emit:@"conn" with:cur completion:^{
                LCLog([NSString stringWithFormat:@"socket.io conn 发送参数完毕%@",cur]);
            }];
        }else{
            if([weakSelf.delegate respondsToSelector:@selector(connectSuccess:)]){
                [weakSelf.delegate connectSuccess:arr];
            }
        }
       
    }];
    [self.socketClient on:@"disconnect" callback:^(NSArray * _Nonnull arr, SocketAckEmitter * _Nonnull ack) {
        LCLog(@"socket.io disconnect -- %@",arr);
        if([weakSelf.delegate respondsToSelector:@selector(disConnect:)]){
            [weakSelf.delegate disConnect:arr];
        }
    }];
    [self.socketClient on:@"error" callback:^(NSArray* arr, SocketAckEmitter* ack) {
        LCLog(@"socket.io error -- %@",arr);
        if([weakSelf.delegate respondsToSelector:@selector(connectFailured:)]){
            [weakSelf.delegate connectFailured:arr[0]];
        }
    }];
    [self.socketClient on:@"conn" callback:^(NSArray* arr, SocketAckEmitter* ack) {
        LCLog(@"进入房间:%@",arr);
        if([weakSelf.delegate respondsToSelector:@selector(connectSuccess:)]){
            [weakSelf.delegate connectSuccess:arr];
        }
        
    }];
    [self.socketClient on:@"broadcastingListen" callback:^(NSArray* arr, SocketAckEmitter* ack) {
        LCLog(@"收到消息：%@",arr);
        if([weakSelf.delegate respondsToSelector:@selector(receiveMessage:)]){
            [weakSelf.delegate receiveMessage:arr];
        }
       
        
    }];
    [self.socketClient on:@"game" callback:^(NSArray* arr, SocketAckEmitter* ack) {
        LCLog(@"收到game消息：%@",arr);
        if([[arr firstObject] isKindOfClass:NSString.class]){
            NSDictionary *dic = [[arr firstObject] mj_JSONObject];
            NSArray *msg = dic[@"msg"];
            NSDictionary *msgDic = [[msg firstObject] mj_JSONObject];
            if([msgDic[@"_method_"] isEqualToString:@"gameinfo"]){
                [[NSNotificationCenter defaultCenter]postNotificationName:LCLiveLotteryTicketTimeCutDownNot object:msgDic];
            }else if ([msgDic[@"_method_"] isEqualToString:@"zhongjiang"]){
                [[NSNotificationCenter defaultCenter]postNotificationName:LCLiveLotteryTicketKaijiangSocketFakeResultNot object:msgDic];

            }else if ([msgDic[@"_method_"] isEqualToString:@"xiazhu"]){


                [[NSNotificationCenter defaultCenter]postNotificationName:LCLiveLotteryTicketFakeGenTouSocketNot object:[msgDic[@"ct"] mj_JSONObject]];
            }else if ([msgDic[@"_method_"] isEqualToString:@"checkgame"]){
                [[NSNotificationCenter defaultCenter]postNotificationName:LCLiveLotteryTicketKaijiangSocketResultNot object:[msgDic[@"ct"] mj_JSONObject]];
            }
            
        }
        
//        if([weakSelf.delegate respondsToSelector:@selector(receiveMessage:)]){
//            [weakSelf.delegate receiveMessage:arr];
//        }
       
        
    }];
//    [self.socketClient on:@"checkgame" callback:^(NSArray* arr, SocketAckEmitter* ack) {
//        LCLog(@"收到checkgame消息：%@",arr);
//        if([[arr firstObject] isKindOfClass:NSString.class]){
//            NSDictionary *dic = [[arr firstObject] mj_JSONObject];
//            NSArray *msg = dic[@"msg"];
//            
//            [[NSNotificationCenter defaultCenter]postNotificationName:LCLiveLotteryTicketKaijiangSocketResultNot object:[[msg firstObject] mj_JSONObject]];
//        }
//        
////        if([weakSelf.delegate respondsToSelector:@selector(receiveMessage:)]){
////            [weakSelf.delegate receiveMessage:arr];
////        }
//       
//        
//    }];
}
- (void)sendMessage:(NSArray *)arr eventName:(NSString *)eventName{
    [self.socketClient emit:eventName with:arr completion:^{
        LCLog([NSString stringWithFormat:@"socket.io conn 发送参数完毕eventName：%@参数：%@",eventName,arr]);
    }];
}
- (void)disconnect{
    if (self.socketClient) {
        [self.socketManager disconnectSocket:self.socketClient];
        [self.socketClient leaveNamespace];
        [self.socketClient disconnect];
        [self.socketClient off:@""];
        [self.socketClient removeAllHandlers];
//        [self.socketClient leaveNamespace];
        self.socketClient = nil;
        self.socketManager = nil;
        _delegate = nil;
    }
}
//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//
//    }
//    return self;
//}
@end
