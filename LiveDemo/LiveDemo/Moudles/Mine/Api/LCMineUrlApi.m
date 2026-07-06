//
//  LCMineUrlApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/24.
//

#import "LCMineUrlApi.h"

@implementation LCMineUrlApi
- (NSString *)requestUrl{
    return @"User.UserCentermenu";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestParams{
    return nil;
}
@end
