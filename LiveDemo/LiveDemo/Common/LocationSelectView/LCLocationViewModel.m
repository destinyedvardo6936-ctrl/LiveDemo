//
//  LCLocationViewModel.m
//  LiveDemo
//
//  Created by mrgao on 2022/11/24.
//

#import "LCLocationViewModel.h"
#import "LCLocationsApi.h"
@implementation LCLocationViewModel
- (void)lc_initialize{
    [self lc_bindLoadSignal];
    
}
- (LCBaseApi *)getLoadApi{
    LCLocationsApi *api = [LCLocationsApi new];
    return api;
}
- (id)dealWithLoadData:(id)result{
    return result;
}
- (void)dealWithLoadError:(NSError *)error{
    
}
#pragma mark---- 懒加载 ----
- (NSMutableArray *)dataArray{
    if (_dataArray == nil){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
