//
//  LCGameWinningHistoryListApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/3/17.
//

#import "LCGameWinningHistoryListApi.h"

@implementation LCGameWinningHistoryListApi
- (NSString *)requestUrl{
    return @"Lottery.history";
}
- (NSString *)requestMethod{
    return @"GET";
}
- (NSDictionary *)requestListParams{
    if(self.biaoshi.length){
        return @{@"biaoshi":self.biaoshi};
    }
    return nil;
}
@end
