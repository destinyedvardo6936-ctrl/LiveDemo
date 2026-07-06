//
//  LCMyWalletApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/17.
//

#import "LCMyWalletApi.h"

@implementation LCMyWalletApi
- (NSString *)requestUrl{
    return @"User.GetBalance";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestParams{
    NSString *app_Version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return @{@"type":@"1",@"version_ios":app_Version};
}
@end
