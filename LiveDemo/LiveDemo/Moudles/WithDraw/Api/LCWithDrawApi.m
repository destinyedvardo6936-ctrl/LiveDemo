//
//  LCWithDrawApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/23.
//

#import "LCWithDrawApi.h"

@implementation LCWithDrawApi
- (NSString *)requestUrl{
    return @"User.SetCash";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestParams{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if(self.accountId.length){
        dic[@"accountid"] = self.accountId;
    }
    if(self.money.length){
        dic[@"cashvote"] = self.money;
    }
    return dic;
}
@end
