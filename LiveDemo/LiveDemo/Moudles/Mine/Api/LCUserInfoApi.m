//
//  LCUserInfoApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/1/4.
//

#import "LCUserInfoApi.h"

@implementation LCUserInfoApi
- (NSString *)requestUrl{
    return @"User.GetBaseInfo";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestParams{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if(self.userId.length){
        dic[@"uid"] = self.userId;
    }
    if(self.userToken.length){
        dic[@"token"] = self.userToken;
    }
    return dic;
}
@end
