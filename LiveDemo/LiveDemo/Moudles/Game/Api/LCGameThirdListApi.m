//
//  LCGameThirdListApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/6/4.
//

#import "LCGameThirdListApi.h"

@implementation LCGameThirdListApi
- (NSString *)requestUrl{
    return @"Caipiao.gettwoclass";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestParams{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if(self.pid.length){
        dic[@"pid"] = self.pid;
    }
    if(self.oneClassId.length){
        dic[@"oneclass_id"] = self.oneClassId;
    }
    return dic;
}
@end
