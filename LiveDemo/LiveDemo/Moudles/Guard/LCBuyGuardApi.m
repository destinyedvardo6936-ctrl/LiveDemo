//
//  LCBuyGuardApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/3/24.
//

#import "LCBuyGuardApi.h"

@implementation LCBuyGuardApi
- (NSString *)requestUrl{
    return @"Guard.BuyGuard";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestParams{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if(self.liveuid.length){
        dic[@"liveuid"] = self.liveuid;
    }
    if(self.stream.length){
        dic[@"stream"] = self.stream;
    }
    if(self.guardid.length){
        dic[@"guardid"] = self.guardid;
    }
    return dic;
}
@end
