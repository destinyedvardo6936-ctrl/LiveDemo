//
//  LCGuideApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/1/3.
//

#import "LCGuideApi.h"

@implementation LCGuideApi
- (NSString *)requestUrl{
    return @"Guide.GetGuide";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestParams{
    return nil;
}
@end
