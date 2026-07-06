//
//  LCHomeSegmentsApi.m
//  liveCommon
//
//  Created by mrgao on 2022/9/29.
//

#import "LCHomeSegmentsApi.h"

@implementation LCHomeSegmentsApi

- (NSString *)requestUrl{
    return @"Home.GetLiveType";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestParams{
    return nil;
}
@end
