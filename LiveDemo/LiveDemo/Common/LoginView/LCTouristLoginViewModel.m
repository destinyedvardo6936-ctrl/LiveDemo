//
//  LCTouristLoginViewModel.m
//  LiveDemo
//
//  Created by mrgao on 2023/1/31.
//

#import "LCTouristLoginViewModel.h"
#import "LCTouristLoginApi.h"
@implementation LCTouristLoginViewModel
- (void)lc_initialize{
    [self lc_bindLoadSignal];
}
- (LCBaseApi *)getLoadApi{
    LCTouristLoginApi *api = [LCTouristLoginApi new];
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
