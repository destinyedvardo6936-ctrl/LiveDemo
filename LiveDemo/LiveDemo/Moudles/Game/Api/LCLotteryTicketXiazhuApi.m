//
//  LCLotteryTicketXiazhuApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/3/23.
//

#import "LCLotteryTicketXiazhuApi.h"

@implementation LCLotteryTicketXiazhuApi
- (NSString *)requestUrl{
    return @"Caipiao.touzhu";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestParams{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if(self.zhuboid.length){
        dic[@"zhuboid"] = self.zhuboid;
    }
    if(self.biaoshi.length){
        dic[@"biaoshi"] = self.biaoshi;
    }
    if(self.wanfaxiid.length){
        dic[@"wanfaxiid"] = self.wanfaxiid;
    }
    if(self.zhushu.length){
        dic[@"zhushu"] = self.zhushu;
    }
    if(self.beishu.length){
        dic[@"beishu"] = self.beishu;
    }
    if(self.money.length){
        dic[@"money"] = self.money;
    }
    if(self.value.length){
        dic[@"value"] = self.value;
    }
    return dic;
}
@end
