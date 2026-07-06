//
//  LCRecommendReplaceLiveApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/1/2.
//

#import "LCRecommendReplaceLiveApi.h"

@implementation LCRecommendReplaceLiveApi
- (NSString *)requestUrl{
    return @"Home.GetTuijian";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestParams{
    return nil;
}
@end
