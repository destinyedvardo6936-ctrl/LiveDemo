//
//  LCCustomGameListApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/3/17.
//

#import "LCCustomGameListApi.h"

@implementation LCCustomGameListApi
- (NSString *)requestUrl{
    return @"Lottery.GetLottery_list";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestParams{
//    if(self.typeId.length){
//        return @{@"id":self.typeId};
//    }
    return nil;
}
@end
