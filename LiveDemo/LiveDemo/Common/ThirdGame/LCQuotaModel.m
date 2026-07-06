//
//  LCQuotaModel.m
//  LiveDemo
//
//  Created by mrgao on 2023/5/10.
//

#import "LCQuotaModel.h"

@implementation LCQuotaModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"modelId":@"id"};
}
@end
