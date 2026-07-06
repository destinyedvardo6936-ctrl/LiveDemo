//
//  LCGameStatusApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/1/2.
//

#import "LCGameStatusApi.h"

@implementation LCGameStatusApi
- (NSString *)requestUrl{
    return @"Home.GetGameStatus";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestParams{
    return nil;
}
@end
