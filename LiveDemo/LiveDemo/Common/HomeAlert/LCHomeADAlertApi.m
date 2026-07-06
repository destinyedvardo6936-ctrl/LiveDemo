//
//  LCHomeADAlertApi.m
//  LiveDemo
//
//  Created by mrgao on 2024/7/28.
//

#import "LCHomeADAlertApi.h"

@implementation LCHomeADAlertApi
- (NSString *)requestUrl{
    return @"home.tanchuang";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestParams{
    return @{@"pid":@"0"};
}
@end
