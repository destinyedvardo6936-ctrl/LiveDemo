//
//  LCUserInfoModel.m
//  liveCommon
//
//  Created by mrgao on 2022/9/29.
//

#import "LCUserInfoModel.h"

@implementation LCUserInfoModel
+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
        @"ID":@"id",@"vip_type":@"vip.type",@"liang_name":@"liang.name"
             };
    
}
@end
