//
//  LCGuardListApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/3/24.
//

#import "LCGuardListApi.h"

@implementation LCGuardListApi
- (NSString *)requestUrl{
    return @"Guard.GetGuardList";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestListParams{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if(self.liveId.length){
        dic[@"liveuid"] = self.liveId;
    }
    dic[@"p"] = @(self.page);
    return dic;
}
@end
