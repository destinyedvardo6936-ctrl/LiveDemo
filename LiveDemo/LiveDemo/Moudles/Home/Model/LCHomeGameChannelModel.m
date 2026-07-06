//
//  LCHomeGameChannelModel.m
//  LiveDemo
//
//  Created by mrgao on 2024/7/30.
//

#import "LCHomeGameChannelModel.h"

@implementation LCHomeGameChannelModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"channelId":@"id"};
}
@end
