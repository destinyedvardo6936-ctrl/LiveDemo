//
//  LCHuiShouApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/6/9.
//

#import "LCHuiShouApi.h"

@implementation LCHuiShouApi
- (NSString *)requestUrl{
    return @"Gameapi.guiji";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestParams{
    return nil;
}
@end
