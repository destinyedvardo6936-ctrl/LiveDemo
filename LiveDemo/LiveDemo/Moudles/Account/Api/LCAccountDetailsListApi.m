//
//  LCAccountDetailsListApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/6/8.
//

#import "LCAccountDetailsListApi.h"

@implementation LCAccountDetailsListApi
- (NSString *)requestUrl{
    return @"User.Details";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestListParams{
    return nil;
}
@end
