//
//  LCQuatoBalanceApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/5/10.
//

#import "LCQuatoBalanceApi.h"

@implementation LCQuatoBalanceApi
- (NSString *)requestMethod{
    return @"POST";
}
- (NSString *)requestUrl{
    return @"Gameapi.getbalance";
}
- (NSDictionary *)requestParams{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if(self.biaoshi.length){
        dic[@"biaoshi"] = self.biaoshi;
    }
    if(self.type.length){
        dic[@"type"] = self.type;
    }
    if(self.code.length){
        dic[@"code"] = self.code;
    }
    return dic;
    
    
}
@end
