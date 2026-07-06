//
//  LCRechargeTypeApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/1/4.
//

#import "LCRechargeTypeApi.h"

@implementation LCRechargeTypeApi
- (NSString *)requestUrl{
    return @"Charge.Getqudao";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestParams{
    return nil;
}
@end
