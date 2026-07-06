//
//  LCUserHomeApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/22.
//

#import "LCUserHomeApi.h"

@implementation LCUserHomeApi
- (NSString *)requestUrl{
    return @"User.GetUserHome";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestParams{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if(self.userId.length){
        dic[@"touid"] = self.userId;
    }
       
    
    
    return dic;
}
@end
