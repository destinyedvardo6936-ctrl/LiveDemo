//
//  LCVideoListModel.m
//  LiveDemo
//
//  Created by mrgao on 2023/5/7.
//

#import "LCVideoListModel.h"

@implementation LCVideoListModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"modelId":@"id"};
}
@end
