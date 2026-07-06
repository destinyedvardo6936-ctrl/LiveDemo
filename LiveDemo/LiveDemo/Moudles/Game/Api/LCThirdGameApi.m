//
//  LCThirdGameApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/5/9.
//

#import "LCThirdGameApi.h"

@implementation LCThirdGameApi
- (NSString *)requestUrl{
    return @"Gameapi.entergame";
}
- (NSString *)requestMethod{
    return @"POST";
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
