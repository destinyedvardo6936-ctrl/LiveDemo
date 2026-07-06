//
//  LCHomeNearbyListApi.m
//  LiveDemo
//
//  Created by mrgao on 2022/12/31.
//

#import "LCHomeNearbyListApi.h"

@implementation LCHomeNearbyListApi
- (NSString *)requestUrl{
    return @"Home.GetNearby";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestListParams{
    return nil;
}
@end
