//
//  LCAreaNumberViewModel.m
//  LiveDemo
//
//  Created by mrgao on 2023/1/31.
//

#import "LCAreaNumberViewModel.h"
#import "LCAreaNumberApi.h"
@implementation LCAreaNumberViewModel
- (void)lc_initialize{
    [self lc_bindLoadSignal];
}
- (LCBaseApi *)getLoadApi{
    LCAreaNumberApi *api = [LCAreaNumberApi new];
    return api;
}
- (id)dealWithLoadData:(id)result{
    if([result isKindOfClass:NSDictionary.class]){
        [LCAreaNumberSectionModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"lists":@"LCAreaNumberModel"};
        }];
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:[LCAreaNumberSectionModel mj_objectArrayWithKeyValuesArray:result[@"info"]]];
    }
    return result;
}
- (void)dealWithLoadError:(NSError *)error{
    
}
#pragma mark---- 懒加载 ----
- (NSMutableArray *)dataArray{
    if(!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
