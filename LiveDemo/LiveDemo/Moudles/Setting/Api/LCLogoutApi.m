//
//  LCLogoutApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/5/10.
//

#import "LCLogoutApi.h"

@implementation LCLogoutApi
- (NSString *)requestUrl{
    return @"Login.Logout";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestParams{
    return nil;
}
@end
