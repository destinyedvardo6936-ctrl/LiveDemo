//
//  LCLotteryTicketPlayModel.m
//  LiveDemo
//
//  Created by mrgao on 2023/3/18.
//

#import "LCLotteryTicketPlayModel.h"

@implementation LCLotteryTicketWanFaModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"modelId":@"id"};
}
@end
@implementation LCLotteryTicketCoinModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"modelId":@"id"};
}
@end
@implementation LCLotteryTicketSQKJModel

@end
@implementation LCLotteryTicketPlayModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"wanfa":@"LCLotteryTicketWanFaModel",@"sqkj":@"LCLotteryTicketSQKJModel",@"coinimg":@"LCLotteryTicketCoinModel"};
}
@end
