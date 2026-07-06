//
//  LCConfigManager.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/24.
//

#import "LCConfigManager.h"
#import "LCConfigApi.h"
#import "LCLocalDataTools.h"
#import "LCKeFuUrlApi.h"
#import "LCLanguageManager.h"
#import "LCCheckAgentApi.h"
#import "LCBindAgentApi.h"
@implementation LCConfigManager
+ (instancetype)shareManager{
    static dispatch_once_t onceToken;
    static LCConfigManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[LCConfigManager alloc]init];
       
    });
    return manager;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self fillWithData];
        WS(weakSelf)
        [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:LCLoginNot object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
            [weakSelf updateAgentInfo];
        }];
    }
    return self;
}
/// 更新配置信息
- (void)updateConfigInfo{
    WS(weakSelf)
    [[LCNetWorkManager manager] requestApi:[LCConfigApi new] success:^(id  _Nullable result) {
        if([result isKindOfClass:NSDictionary.class]){
            NSArray *a = result[@"info"];
            NSDictionary *dic = [a firstObject];
            [LCLocalDataTools saveLoacalDataWithKey:configInfoSavePath object:dic catheType:LCLocalDataToolsSaveType_Library];
            [weakSelf fillWithData];
            
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
    LCKeFuUrlApi *api = [LCKeFuUrlApi new];
    
    [[LCNetWorkManager manager] requestApi:api success:^(id  _Nullable result) {
        if([result isKindOfClass:NSDictionary.class]){
            NSArray *arr = result[@"info"];
            NSDictionary *dic = [arr firstObject];
            weakSelf.kefuUrl = [NSString stringWithFormat:@"%@&lang=%@",dic[@"kefuurl"],[[LCLanguageManager shareManager]getLanguageEncode]];
            
           
            
        }else{
            
            
        
    }
       
    } failure:^(NSError * _Nullable error) {
       
    }];
    
    [weakSelf updateAgentInfo];
}
- (void)updateAgentInfo{
    LCCheckAgentApi *agentApi = [LCCheckAgentApi new];
    WS(weakSelf)
    [[LCNetWorkManager manager] requestApi:agentApi success:^(id  _Nullable result) {
        if([result isKindOfClass:NSDictionary.class]){
            NSArray *arr = result[@"info"];
            NSDictionary *dic = [arr firstObject];
            weakSelf.agentSwitch = [dic[@"agent_switch"] boolValue];
            weakSelf.hasAgent = [dic[@"has_agent"] boolValue];
            
        }else{
        }
       
    } failure:^(NSError * _Nullable error) {
       
    }];
}
- (void)addAgentWithCode:(NSString *)code successBlock:(void(^)(void))successBlock failedBlock:(void(^)(NSError *error))failedBlock{
    LCBindAgentApi *agentApi = [LCBindAgentApi new];
    agentApi.agentCode = code;
    [[LCNetWorkManager manager] requestApi:agentApi success:^(id  _Nullable result) {
        if([result isKindOfClass:NSDictionary.class]){
            successBlock();
            
        }else{
            failedBlock([NSError errorWithDomain:KLanguage(@"请稍后再试") code:500 userInfo:nil]);
        }
       
    } failure:^(NSError * _Nullable error) {
        failedBlock(error);
    }];
}

- (void)fillWithData{
    NSDictionary *dic =  [LCLocalDataTools loadLocalWithKey:configInfoSavePath catcheType:LCLocalDataToolsSaveType_Library];
    if(dic){
        if(_configModel){
            _configModel = [LCConfigModel mj_objectWithKeyValues:dic];
        }else{
            _configModel = [LCConfigModel new];
        }
    }else{
        if(!_configModel){
            _configModel = [LCConfigModel new];
        }
    }
    
   
}
/// 清除配置信息
- (void)clearConfigInfo{
    [LCLocalDataTools deleteLoacalWithKey:configInfoSavePath catheType:LCLocalDataToolsSaveType_Library];
    
    _configModel = [LCConfigModel new];
}
@end
