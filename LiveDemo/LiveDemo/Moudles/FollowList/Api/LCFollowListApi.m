//
//  LCFollowListApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/22.
//

#import "LCFollowListApi.h"

@implementation LCFollowListApi
- (NSString *)requestUrl{
    return @"User.GetFollowsList";
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
