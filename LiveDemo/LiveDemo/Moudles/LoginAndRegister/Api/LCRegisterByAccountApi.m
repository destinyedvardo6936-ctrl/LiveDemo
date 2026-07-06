//
//  LCRegisterByAccountApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/5/7.
//

#import "LCRegisterByAccountApi.h"
#import "NSString+LCExtension.h"
@implementation LCRegisterByAccountApi
- (NSString *)requestUrl{
    return @"Login.userReg";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestParams{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if(self.username.length){
        dic[@"user_login"] = self.username;
    }
    if(self.country_code.length){
        dic[@"country_code"] = self.country_code;
    }
    if(self.password.length){
        dic[@"user_pass"] = self.password;
    }
    if(self.againpassword.length){
        dic[@"user_pass2"] = self.againpassword;
    }
        
    dic[@"IMEI"] = [NSString  stringWithUUID];
    dic[@"source"] = @"ios";
    return dic;
}
@end
