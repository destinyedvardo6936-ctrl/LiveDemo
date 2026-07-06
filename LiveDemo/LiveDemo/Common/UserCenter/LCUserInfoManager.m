//
//  LCUserInfoManager.m
//  liveCommon
//
//  Created by mrgao on 2022/9/29.
//

#import "LCUserInfoManager.h"
#import "LCLocalDataTools.h"
@implementation LCUserInfoManager
+ (instancetype)shareManager{
    static dispatch_once_t onceToken;
    static LCUserInfoManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[LCUserInfoManager alloc]init];
        [manager fillWithLocalData];
    });
    return manager;
}
- (void)fillWithLocalData{
    LCUserInfoModel *model = [LCLocalDataTools loadLocalWithKey:userInfoSavePath catcheType:LCLocalDataToolsSaveType_Library];
//    NSString *token = [LCLocalDataTools loadLocalWithKey:userTokenSavePath catcheType:LCLocalDataToolsSaveType_Library];
    if (model) {
        _userInfo = model;
    }else{
        _userInfo = [LCUserInfoModel new];
    }
    
    
}
/// 更新用户信息
- (void)updateUserInfo:(LCUserInfoModel *)model{
    [LCLocalDataTools saveLoacalDataWithKey:userInfoSavePath object:model catheType:LCLocalDataToolsSaveType_Library];
    [self fillWithLocalData];
}

/// 清除用户信息(退出登录时先清除再更新一遍用户信息)
- (void)clearUserInfo{
    [LCLocalDataTools deleteLoacalWithKey:userInfoSavePath catheType:LCLocalDataToolsSaveType_Library];
    
    _userInfo = [LCUserInfoModel new];
}
@end
