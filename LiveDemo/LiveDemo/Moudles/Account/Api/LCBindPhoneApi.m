//
//  LCBindPhoneApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/6/4.
//

#import "LCBindPhoneApi.h"

@implementation LCBindPhoneApi
- (NSString *)requestUrl{
    return @"User.SetMobile";
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
    if(self.code.length){
        dic[@"code"] = self.code;
    }
   

    return dic;
}
@end
