//
//  LCApplyAgentApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/5/9.
//

#import "LCApplyAgentApi.h"

@implementation LCApplyAgentApi
- (NSString *)requestUrl{
    return @"User.dodaili";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestParams{
    return nil;
}
@end
