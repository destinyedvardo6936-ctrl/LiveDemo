//
//  LCVideoSwichApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/5/10.
//

#import "LCVideoSwichApi.h"

@implementation LCVideoSwichApi
- (NSString *)requestUrl{
    return @"Video.videostatus";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestParams{
    return nil;
}
@end
