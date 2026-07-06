//
//  LCUserInfoManager.h
//  liveCommon
//
//  Created by mrgao on 2022/9/29.
//

#import <Foundation/Foundation.h>
#import "LCUserInfoModel.h"
NS_ASSUME_NONNULL_BEGIN
static NSString * _Nonnull userInfoSavePath = @"LCUserInfoSavePath";
static NSString * _Nonnull userTokenSavePath = @"LCUserTokenSavePath";
//static NSString * _Nonnull userLoginSavePath = @"LCUserLoginSavePath";
//static NSString * _Nonnull userAppleUnionidPath = @"LCUserAppleUnionidPath";
@interface LCUserInfoManager : NSObject
@property (nonatomic , strong ,readonly) LCUserInfoModel *userInfo;
+ (instancetype)shareManager;
/// 更新用户信息
- (void)updateUserInfo:(LCUserInfoModel *)model;

/// 清除用户信息(退出登录时先清除再更新一遍用户信息)
- (void)clearUserInfo;
@end

NS_ASSUME_NONNULL_END
