//
//  LCWithDrawDeleteAccountApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/23.
//

#import "LCWithDrawDeleteAccountApi.h"

@implementation LCWithDrawDeleteAccountApi
- (NSString *)requestUrl{
    return @"User.DelUserAccount";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestParams{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if(self.accountId.length){
        dic[@"id"] = self.accountId;
    }
   
    return dic;
}
@end
