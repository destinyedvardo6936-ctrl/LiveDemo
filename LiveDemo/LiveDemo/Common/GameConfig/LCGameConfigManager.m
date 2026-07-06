//
//  LCGameConfigManager.m
//  LiveDemo
//
//  Created by mrgao on 2023/1/2.
//

#import "LCGameConfigManager.h"
#import "LCGameStatusApi.h"
@implementation LCGameConfigManager
+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    static LCGameConfigManager *manager;

    dispatch_once(&onceToken, ^{
        manager = [[LCGameConfigManager alloc]init];
        
    });
    return manager;
}
- (void)getGameCurrentStatus{
    WS(weakSelf)
    LCGameStatusApi *api = [LCGameStatusApi new];
    [[LCNetWorkManager manager] requestApi:api success:^(id  _Nullable result) {
        if([result isKindOfClass:NSDictionary.class]){
            NSDictionary *info = [result objectForKey:@"info"];
            weakSelf.gameStatus = [info[@"game_status"] boolValue];
            [[NSNotificationCenter defaultCenter] postNotificationName:LCGameStatusNot object:nil];
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
@end
