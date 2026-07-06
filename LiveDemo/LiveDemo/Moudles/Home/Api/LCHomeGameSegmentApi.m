//
//  LCHomeGameSegmentApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/1/1.
//

#import "LCHomeGameSegmentApi.h"

@implementation LCHomeGameSegmentApi
- (NSString *)requestUrl{
    return @"home.tanchuang";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestParams{
    return @{@"pid":@"0"};
}
@end
