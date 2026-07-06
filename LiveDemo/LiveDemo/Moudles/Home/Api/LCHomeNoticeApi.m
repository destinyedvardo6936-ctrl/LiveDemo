//
//  LCHomeNoticeApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/21.
//

#import "LCHomeNoticeApi.h"

@implementation LCHomeNoticeApi
- (NSString *)requestUrl{
    return @"Home.GetNotice";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestParams{
    return nil;
}
@end
