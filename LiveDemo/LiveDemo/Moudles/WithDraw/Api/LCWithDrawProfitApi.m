//
//  LCWIthDrawProfitApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/23.
//

#import "LCWithDrawProfitApi.h"

@implementation LCWithDrawProfitApi
- (NSString *)requestUrl{
    return @"User.GetProfit";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestParams{
    
    return nil;
}
@end
