//
//  LCRechargeRecordListApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/6/8.
//

#import "LCRechargeRecordListApi.h"

@implementation LCRechargeRecordListApi
- (NSString *)requestUrl{
    return @"User.Chongzhilog";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestListParams{
    return nil;
}
@end
