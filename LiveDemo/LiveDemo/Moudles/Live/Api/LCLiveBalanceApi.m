//
//  LCLiveBalanceApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/3/13.
//

#import "LCLiveBalanceApi.h"

@implementation LCLiveBalanceApi
- (NSString *)requestUrl{
    return @"Live.GetCoin";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestParams{
   
    return nil;
}
@end
