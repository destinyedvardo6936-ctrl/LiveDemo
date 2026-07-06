//
//  LCBindCodeApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/6/4.
//

#import "LCBindCodeApi.h"

@implementation LCBindCodeApi
- (NSString *)requestUrl{
    return @"User.GetBindCode";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestParams{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if(self.phone.length){
        dic[@"mobile"] = self.phone;
    }
    if(self.country_code.length){
        dic[@"country_code"] = self.country_code;
    }
    
   
    return dic;
}
@end
