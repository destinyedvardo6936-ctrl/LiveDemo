//
//  LCWithDrawAccountListApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/23.
//

#import "LCWithDrawAccountListApi.h"

@implementation LCWithDrawAccountListApi
- (NSString *)requestUrl{
    return @"User.GetUserAccountList";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestParams{
    return nil;
}
@end
