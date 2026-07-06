//
//  LCWithDrawAddAcountApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/23.
//

#import "LCWithDrawAddAcountApi.h"

@implementation LCWithDrawAddAcountApi
- (NSString *)requestUrl{
    return @"User.SetUserAccount";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestParams{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if(self.type.length){
        dic[@"type"] = self.type;
    }
    if(self.account.length){
        dic[@"account"] = self.account;
    }
    if(self.account_bank.length){
        dic[@"account_bank"] = self.account_bank;
    }
    if(self.name.length){
        dic[@"account"] = self.name;
    }
    return dic;
}
@end
