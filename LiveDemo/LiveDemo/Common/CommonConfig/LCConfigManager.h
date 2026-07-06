//
//  LCConfigManager.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/24.
//

#import <Foundation/Foundation.h>
#import "LCConfigModel.h"
NS_ASSUME_NONNULL_BEGIN
static NSString * _Nonnull configInfoSavePath = @"LCConfigInfoSavePath";
@interface LCConfigManager : NSObject

@property (nonatomic , strong , readonly) LCConfigModel *configModel;
@property (nonatomic , copy) NSString *kefuUrl;
@property (nonatomic , assign) BOOL agentSwitch;
@property (nonatomic , assign) BOOL hasAgent;

+ (instancetype)shareManager;
/// 更新配置信息
- (void)updateConfigInfo;
/// 绑定上下级
- (void)addAgentWithCode:(NSString *)code successBlock:(void(^)(void))successBlock failedBlock:(void(^)(NSError *error))failedBlock;

/// 清除配置信息
- (void)clearConfigInfo;
@end

NS_ASSUME_NONNULL_END
