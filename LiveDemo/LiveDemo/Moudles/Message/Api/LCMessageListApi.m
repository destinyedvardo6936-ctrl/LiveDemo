//
//  LCMessageListApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/22.
//

#import "LCMessageListApi.h"

@implementation LCMessageListApi
- (NSString *)requestUrl{
    return @"Message.GetList";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestListParams{
    return nil;
}

@end
