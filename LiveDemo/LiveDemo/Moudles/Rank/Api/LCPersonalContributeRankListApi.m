//
//  LCPersonalContributeRankListApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/3/30.
//

#import "LCPersonalContributeRankListApi.h"

@implementation LCPersonalContributeRankListApi
- (NSString *)requestUrl{
    return @"User.UserConsumeList";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestListParams{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if(self.userId.length){
//        return @{@"type":self.type};
        dic[@"touid"]  = self.userId;
    }
    
    return dic;
}
@end
