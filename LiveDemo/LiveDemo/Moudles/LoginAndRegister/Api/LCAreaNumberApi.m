//
//  LCAreaNumberApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/1/31.
//

#import "LCAreaNumberApi.h"

@implementation LCAreaNumberApi
- (NSString *)requestUrl{
    return @"Login.GetCountrys";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestParams{
    return nil;
}
@end
