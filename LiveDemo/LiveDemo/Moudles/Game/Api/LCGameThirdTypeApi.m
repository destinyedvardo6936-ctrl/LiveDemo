//
//  LCGameThirdTypeApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/6/4.
//

#import "LCGameThirdTypeApi.h"

@implementation LCGameThirdTypeApi
- (NSString *)requestUrl{
    return @"Caipiao.getoneclass";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestParams{
    if(self.typeId.length){
        return @{@"pid":self.typeId};
    }
    return nil;
}
@end
