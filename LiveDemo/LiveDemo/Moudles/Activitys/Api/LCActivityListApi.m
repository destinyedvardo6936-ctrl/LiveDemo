//
//  LCActivityListApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/1/3.
//

#import "LCActivityListApi.h"

@implementation LCActivityListApi
- (NSString *)requestUrl{
    return @"Activitys.GetActivityList";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestListParams{
    if(self.type.length){
        return @{@"type":self.type};
    }
    return nil;
}
@end
