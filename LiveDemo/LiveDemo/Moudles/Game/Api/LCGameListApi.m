//
//  LCGameListApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/3/17.
//

#import "LCGameListApi.h"

@implementation LCGameListApi
- (NSString *)requestUrl{
    return @"Caipiao.Twoclass";
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
