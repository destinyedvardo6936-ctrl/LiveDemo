//
//  LCFollowApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/1.
//

#import "LCFollowApi.h"

@implementation LCFollowApi
- (NSString *)requestUrl{
    return @"User.SetAttent";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestParams{
    if (self.userId.length){
        return @{@"touid":self.userId,@"uid":[LCUserInfoManager shareManager].userInfo.ID};
    }
    return nil;
}
@end
