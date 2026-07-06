//
//  LCRegisterByAccountViewModel.m
//  LiveDemo
//
//  Created by mrgao on 2023/5/7.
//

#import "LCRegisterByAccountViewModel.h"
#import "LCRegisterByAccountApi.h"
@implementation LCRegisterByAccountViewModel
- (void)lc_initialize{
    [self lc_bindLoadSignal];
    self.country_code = @"86";
    
}
- (LCBaseApi *)getLoadApi{
    LCRegisterByAccountApi *api = [LCRegisterByAccountApi new];
    api.username = self.account;
    api.password = self.passward;
    api.country_code = self.country_code;
    api.againpassword = self.againpassword;
    return api;
}
- (id)dealWithLoadData:(id)result{
    if([result isKindOfClass:NSDictionary.class]){
        NSArray *arr = result[@"info"];
        NSDictionary *dic = [arr firstObject];
        LCUserInfoModel *mdeol = [LCUserInfoModel mj_objectWithKeyValues:dic];
        [[LCUserInfoManager shareManager] updateUserInfo:mdeol];
        [[NSNotificationCenter defaultCenter] postNotificationName:LCLoginNot object:nil];
    }
    return result;
}
- (void)dealWithLoadError:(NSError *)error{
    
}
@end
