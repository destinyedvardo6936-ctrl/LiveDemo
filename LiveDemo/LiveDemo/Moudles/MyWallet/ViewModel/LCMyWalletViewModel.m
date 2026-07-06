//
//  LCMyWalletViewModel.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/17.
//

#import "LCMyWalletViewModel.h"
#import "LCMyWalletApi.h"
@implementation LCMyWalletViewModel
- (void)lc_initialize{
    [self lc_bindLoadSignal];
}
- (LCBaseApi *)getLoadApi{
    LCMyWalletApi *api = [LCMyWalletApi new];
    return api;
}
- (id)dealWithLoadData:(id)result{
    if([result isKindOfClass:NSDictionary.class]){
        NSArray *a = result[@"info"];
        NSDictionary *dic = [a firstObject];
        self.balanceStr = [NSString stringWithFormat:@"%ld",[dic[@"coin"]integerValue]];
        LCUserInfoModel *model = [LCUserInfoManager shareManager].userInfo;
        model.coin = self.balanceStr;
        [[LCUserInfoManager shareManager] updateUserInfo:model];
    }
    return result;
}
- (void)dealWithLoadError:(NSError *)error{
    
}
@end
