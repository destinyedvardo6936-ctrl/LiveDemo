//
//  LCConfigModel.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/24.
//

#import "LCConfigModel.h"

@implementation LCConfigModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"levelanchor":@"LCArchorLevelModel",@"level":@"LCUserLevelModel"};
}
@end
