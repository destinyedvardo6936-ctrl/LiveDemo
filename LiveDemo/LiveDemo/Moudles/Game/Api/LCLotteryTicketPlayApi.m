//
//  LCLotteryTicketPlayApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/3/18.
//

#import "LCLotteryTicketPlayApi.h"

@implementation LCLotteryTicketPlayApi
- (NSString *)requestUrl{
    return @"Caipiao.getwanfa";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestParams{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if(self.gameId.length){
        dic[@"id"] = self.gameId;
    }
    if(self.biaoshi.length){
        dic[@"biaoshi"] = self.biaoshi;
    }

    return dic;
}
@end
