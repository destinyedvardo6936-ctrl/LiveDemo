//
//  LCBettingRecordListApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/3/17.
//

#import "LCBettingRecordListApi.h"

@implementation LCBettingRecordListApi
- (NSString *)requestUrl{
    return @"Lottery.touzhurecord";
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
