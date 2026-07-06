//
//  LCBindAgentApi.m
//  LiveDemo
//
//  Created by mrgao on 2024/6/17.
//

#import "LCBindAgentApi.h"

@implementation LCBindAgentApi
- (NSString *)requestUrl{
    return @"User.setDistribut";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestParams{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"code"] = self.agentCode;
    return dic;
}
@end
