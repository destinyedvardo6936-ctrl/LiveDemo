//
//  LCLiveGiftListApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/3/13.
//

#import "LCLiveGiftListApi.h"

@implementation LCLiveGiftListApi
- (NSString *)requestUrl{
    return @"Live.GetGiftList";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestParams{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
   
        dic[@"live_type"] = @"0";
    
    
    return dic;
}

@end
