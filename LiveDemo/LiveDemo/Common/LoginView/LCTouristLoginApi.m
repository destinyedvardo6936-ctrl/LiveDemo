//
//  LCTouristLoginApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/1/31.
//

#import "LCTouristLoginApi.h"
#import "NSString+LCExtension.h"
@implementation LCTouristLoginApi
- (NSString *)requestUrl{
    return @"Login.TouristLogin";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestParams{
    NSString *deviceId = [NSString getUUIDInKeychain];
    return @{@"IMEI":deviceId,@"source":@"ios"};
}
@end
