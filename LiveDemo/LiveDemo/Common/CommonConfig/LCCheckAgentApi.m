//
//  LCCheckAgentApi.m
//  LiveDemo
//
//  Created by mrgao on 2024/6/17.
//

#import "LCCheckAgentApi.h"

@implementation LCCheckAgentApi
- (NSString *)requestUrl{
    return @"Agent.checkAgent";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestParams{
    return nil;
}
@end
