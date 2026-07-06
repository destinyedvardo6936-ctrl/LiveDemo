//
//  LCLoginApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/1/17.
//

#import "LCLoginApi.h"
#import "NSString+LCExtension.h"
@implementation LCLoginApi
- (NSString *)requestUrl{
    return @"Login.LoginOrReg";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestParams{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if(self.phone.length){
        dic[@"user_login"] = self.phone;
    }
    if(self.country_code.length){
        dic[@"country_code"] = self.country_code;
    }
    if(self.code.length){
        dic[@"code"] = self.code;
    }
   
        
    dic[@"IMEI"] = [NSString  stringWithUUID];
    dic[@"source"] = @"ios";
    return dic;
}
@end
