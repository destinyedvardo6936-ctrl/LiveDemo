//
//  LCQuotaGameLisApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/5/10.
//

#import "LCQuotaGameLisApi.h"

@implementation LCQuotaGameLisApi
- (NSString *)requestMethod{
    return @"POST";
}
- (NSString *)requestUrl{
    return @"Gameapi.getmylist";
}
- (NSDictionary *)requestListParams{
   
    return nil;
    
    
}
@end
