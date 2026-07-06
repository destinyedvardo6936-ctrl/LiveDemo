//
//  LCArchorRankListApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/2.
//

#import "LCArchorRankListApi.h"

@implementation LCArchorRankListApi
- (NSString *)requestUrl{
    return @"Home.ProfitList";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestListParams{
    if(self.type.length){
        return @{@"type":self.type};
//        return @{@"type":@"total"};
    }
    return nil;
}
@end
