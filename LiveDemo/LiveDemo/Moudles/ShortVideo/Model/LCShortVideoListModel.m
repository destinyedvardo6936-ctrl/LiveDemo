//
//  LCShortVideoListModel.m
//  LiveDemo
//
//  Created by mrgao on 2023/5/8.
//

#import "LCShortVideoListModel.h"

@implementation LCShortVideoListModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"modelId":@"id"};
}
@end
