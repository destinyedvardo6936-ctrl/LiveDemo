//
//  LCLotteryTicketResultApi.m
//  LiveDemo
//
//  Created by mrgao on 2023/3/25.
//

#import "LCLotteryTicketResultApi.h"

@implementation LCLotteryTicketResultApi
- (NSString *)requestUrl{
    return @"Caipiao.check";
}
- (NSString *)requestMethod{
    return @"POST";
}
- (NSDictionary *)requestParams{
    if(self.biaoshi.length){
        return @{@"baisohi":self.biaoshi};
    }
    return nil;
}
@end
