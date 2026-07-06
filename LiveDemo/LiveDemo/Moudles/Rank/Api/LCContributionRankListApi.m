//
//  LCContributionRankListApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/3.
//

#import "LCContributionRankListApi.h"

@implementation LCContributionRankListApi
- (NSString *)requestUrl{
    return @"Home.ConsumeList";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestListParams{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if(self.type.length){
//        return @{@"type":self.type};
        dic[@"type"]  = self.type;
    }
    
    return dic;
}
@end
