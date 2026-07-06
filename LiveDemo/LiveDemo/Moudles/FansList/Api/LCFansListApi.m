//
//  LCFansListApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/22.
//

#import "LCFansListApi.h"

@implementation LCFansListApi
- (NSString *)requestUrl{
    return @"User.GetFansList";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestListParams{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if(self.userId.length){
        dic[@"touid"] = self.userId;
    }
       
    
    
    return dic;
}

@end
