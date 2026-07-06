//
//  LCGameEdhsApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/6/8.
//

#import "LCGameEdhsApi.h"

@implementation LCGameEdhsApi
- (NSString *)requestUrl{
    return @"Gameapi.huishou";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestParams{
    return nil;
}
@end
