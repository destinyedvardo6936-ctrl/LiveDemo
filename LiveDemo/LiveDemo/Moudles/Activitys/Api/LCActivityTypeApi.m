//
//  LCActivityTypeApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/15.
//

#import "LCActivityTypeApi.h"

@implementation LCActivityTypeApi
- (NSString *)requestUrl{
    return @"Activitys.GetType";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestParams{
    return nil;
}
@end
