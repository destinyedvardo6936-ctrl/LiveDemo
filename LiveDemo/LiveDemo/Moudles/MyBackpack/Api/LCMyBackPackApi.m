//
//  LCMyBackPackApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/22.
//

#import "LCMyBackPackApi.h"

@implementation LCMyBackPackApi
- (NSString *)requestUrl{
    return @"Backpack.GetBackpack";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestListParams{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
   
        dic[@"live_type"] = @"0";
    
    
    return dic;
}

@end
