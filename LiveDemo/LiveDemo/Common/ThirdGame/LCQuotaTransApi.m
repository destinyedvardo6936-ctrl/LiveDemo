//
//  LCQuotaTransApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/5/10.
//

#import "LCQuotaTransApi.h"

@implementation LCQuotaTransApi
- (NSString *)requestMethod{
    return @"POST";
}
- (NSString *)requestUrl{
    return @"Gameapi.trans";
}
- (NSDictionary *)requestParams{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if(self.biaoshi.length){
        dic[@"biaoshi"] = self.biaoshi;
    }
    if(self.action.length){
        dic[@"action"] = self.action;
    }
    if(self.amount.length){
        dic[@"amount"] = self.amount;
    }
    return dic;
    
    
}
@end
