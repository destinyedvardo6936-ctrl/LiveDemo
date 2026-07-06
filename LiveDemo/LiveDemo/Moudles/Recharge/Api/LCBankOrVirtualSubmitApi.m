//
//  LCBankOrVirtualSubmitApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/16.
//

#import "LCBankOrVirtualSubmitApi.h"

@implementation LCBankOrVirtualSubmitApi
- (NSString *)requestUrl{
    return @"Charge.Submitpay";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestParams{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if(self.qudaoid){
        dic[@"qudaoid"] = self.qudaoid;
        
    }
    if(self.name){
        dic[@"name"] = self.name;
        
    }
    if(self.moneylistid){
        dic[@"moneylistid"] = self.moneylistid;
        
    }
    if(self.money){
        dic[@"money"] = self.money;
        
    }
    return dic;
}
@end
