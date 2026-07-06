//
//  LCCheckVersionApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/1/7.
//

#import "LCCheckVersionApi.h"

@implementation LCCheckVersionApi
- (NSString *)requestUrl{
    return @"Home.Getversion";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestParams{
    return @{@"type":@"ios"};
}
@end
