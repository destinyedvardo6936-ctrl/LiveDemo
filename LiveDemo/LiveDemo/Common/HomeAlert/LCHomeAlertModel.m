//
//  LCHomeAlertModel.m
//  LiveDemo
//
//  Created by mrgao on 2024/7/27.
//

#import "LCHomeAlertModel.h"

@implementation LCHomeAlertModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"alertId":@"id",@"des":@"description"};
}
@end
