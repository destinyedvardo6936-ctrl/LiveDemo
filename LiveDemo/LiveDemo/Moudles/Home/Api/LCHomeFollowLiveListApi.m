//
//  LCHomeFollowLiveListApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/1/1.
//

#import "LCHomeFollowLiveListApi.h"

@implementation LCHomeFollowLiveListApi
- (NSString *)requestUrl{
    return @"Home.GetFollow";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestListParams{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if ([LCUserInfoManager shareManager].userInfo.ID.length){
        dic[@"uid"] = [LCUserInfoManager shareManager].userInfo.ID;
    }
    dic[@"live_type"] = @(0);
    return dic;
}
@end
