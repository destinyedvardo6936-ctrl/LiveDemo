//
//  LCLotteryTicketSocketInfoApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/3/30.
//

#import "LCLotteryTicketSocketInfoApi.h"

@implementation LCLotteryTicketSocketInfoApi
- (NSString *)requestUrl{
    return @"Home.GetSocket";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestParams{
    return nil;
}
@end
