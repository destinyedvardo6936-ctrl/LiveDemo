//
//  LCCodeApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/1/17.
//

#import "LCCodeApi.h"
#import "NSString+LCHash.h"
@implementation LCCodeApi
- (NSString *)requestUrl{
    return @"Login.GetLoginOrRegCode";
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
    if(self.phone.length){
        
        dic[@"sign"] = [[NSString stringWithFormat:@"mobile=%@&76576076c1f5f657b634e966c8836a06",self.phone] md5String];
    }
   
    return dic;
}
@end
