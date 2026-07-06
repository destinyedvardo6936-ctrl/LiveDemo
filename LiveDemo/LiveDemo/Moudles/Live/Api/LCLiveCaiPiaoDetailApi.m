//
//  LCLiveCaiPiaoDetailApi.m
//  LiveDemo
//
//  Created by mrgao on 2022/12/2.
//

#import "LCLiveCaiPiaoDetailApi.h"

@implementation LCLiveCaiPiaoDetailApi
- (NSString *)requestUrl{
    return @"/api/public/?service=Caipiao.getwanfa";
}
- (NSString *)requestMethod{
    return @"GET";
}
- (NSDictionary *)requestParams{
    if(self.biaoshi.length && self.gameId.length){
        return @{@"biaoshi":self.biaoshi,@"id":self.gameId};
    }
    return nil;
}
@end
