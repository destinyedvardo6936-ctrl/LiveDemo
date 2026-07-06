//
//  LCLiveBackPackGiftListApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/3/13.
//

#import "LCLiveBackPackGiftListApi.h"

@implementation LCLiveBackPackGiftListApi
- (NSString *)requestUrl{
    return @"Backpack.GetBackpack";
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
