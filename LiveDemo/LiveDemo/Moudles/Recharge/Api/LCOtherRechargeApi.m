//
//  LCOtherRechargeApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/16.
//

#import "LCOtherRechargeApi.h"

@implementation LCOtherRechargeApi
- (NSString *)requestUrl{
    return @"charge.getchargeorders";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestParams{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if(self.qudaoid){
        dic[@"qudaoid"] = self.qudaoid;
        
    }
    if(self.paytypeid){
        dic[@"paytypecode"] = self.paytypeid;
        
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
