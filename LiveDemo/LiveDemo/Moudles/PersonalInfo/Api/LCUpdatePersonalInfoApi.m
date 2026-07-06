//
//  LCUpdatePersonalInfoApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/18.
//

#import "LCUpdatePersonalInfoApi.h"

@implementation LCUpdatePersonalInfoApi
- (NSString *)requestUrl{
    return @"User.UpdateFields";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestParams{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if(self.nickname.length){
        dic[@"user_nicename"] = self.nickname;
    }
    if(self.avaterStr.length){
        dic[@"avatar"] = self.avaterStr;
    }
    if(self.sex.length){
        dic[@"sex"] = self.sex;
    }
    if(self.profile.length){
        dic[@"signature"] = self.profile;
    }
    if(self.province.length){
        dic[@"province"] = self.province;
    }
    if(self.city.length){
        dic[@"city"] = self.city;
    }
    if(self.birthday.length){
        dic[@"birthday"] = self.birthday;
    }
    NSString *jsonStr = [dic mj_JSONString];
    if(jsonStr.length){
        return @{@"fields":jsonStr};
    }
    return nil;
}
@end
