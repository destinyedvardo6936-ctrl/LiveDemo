//
//  LCConfigApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/24.
//

#import "LCConfigApi.h"

@implementation LCConfigApi
- (NSString *)requestUrl{
    return @"Home.GetConfig";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestParams{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
   
        dic[@"source"] = @"app";
    
    
    return dic;
}
@end
