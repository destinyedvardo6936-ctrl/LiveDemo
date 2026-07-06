//
//  LCGameWinningHistoryViewModel.m
//  LiveDemo
//
//  Created by mrgao on 2023/3/17.
//

#import "LCGameWinningHistoryViewModel.h"
#import "LCGameWinningHistoryListApi.h"
@implementation LCGameWinningHistoryViewModel
- (void)lc_initialize{
    [self lc_bindLoadSignal];
    [self lc_bindLoadMoreSignal];
  
}
- (LCBaseApi *)getLoadApi{
   
    LCGameWinningHistoryListApi *api = [LCGameWinningHistoryListApi new];
    api.biaoshi = self.biaoshi;
    self.listApi = api;
    return api;
}
- (LCBaseListApi *)getPageApi{
    
    return self.listApi;
}
- (id)dealWithLoadMoreData:(id)result{
    if([result isKindOfClass:NSDictionary.class]){
        NSArray *arr = result[@"info"];
        
            [self.dataArray addObjectsFromArray:[LCGameWinningHistoryModel mj_objectArrayWithKeyValuesArray:arr]];
        
    }
    return result;
}
- (void)dealWithLoadError:(NSError *)error{
    
}
- (id)dealWithLoadData:(id)result{
    if([result isKindOfClass:NSDictionary.class]){
        NSArray *arr = result[@"info"];
        [self.dataArray removeAllObjects];
        
        [self.dataArray addObjectsFromArray:[LCGameWinningHistoryModel mj_objectArrayWithKeyValuesArray:arr]];
            
           
        
    }
    return result;
}
- (void)dealWithLoadMoreError:(NSError *)error{
    
}
- (BOOL)dealWithNoPageWithData:(id)result{
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = result ;
       
       
        if (dic[@"info"]){
            NSArray *arr = dic[@"info"];
            return arr.count ? NO : YES;
        }
        
        
    }
    return NO;
}
#pragma mark---- 懒加载 ----
- (NSMutableArray *)dataArray{
    if (!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
