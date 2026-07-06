//
//  LCTotalBCBettingRecordListApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/5/9.
//

#import "LCTotalBCBettingRecordListApi.h"

@implementation LCTotalBCBettingRecordListApi
- (NSString *)requestUrl{
    return @"Game.bcgamelog";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestListParams{
  
    return nil;
}
@end
