//
//  LCGuardPriceApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/3/24.
//

#import "LCGuardPriceApi.h"

@implementation LCGuardPriceApi
- (NSString *)requestUrl{
    return @"Guard.GetList";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestParams{
    return nil;
}
@end
