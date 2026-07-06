//
//  LCRechargeAmountApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/15.
//

#import "LCRechargeAmountApi.h"

@implementation LCRechargeAmountApi
- (NSString *)requestUrl{
    return @"Charge.Getcharge_rules";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestParams{
    if(self.qudaoid){
        return @{@"qudaoid":self.qudaoid};
    }
    return nil;
}
@end
