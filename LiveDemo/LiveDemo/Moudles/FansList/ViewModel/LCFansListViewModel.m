//
//  LCFansListViewModel.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/22.
//

#import "LCFansListViewModel.h"
#import "LCFansListApi.h"
@implementation LCFansListViewModel
- (void)lc_initialize{
    [self lc_bindLoadSignal];
    [self lc_bindLoadMoreSignal];
  
}
- (LCBaseApi *)getLoadApi{
   
    LCFansListApi *api = [LCFansListApi new];
    api.userId = self.userId;
    self.listApi = api;
    return api;
}
- (LCBaseListApi *)getPageApi{
    
    return self.listApi;
}
- (id)dealWithLoadMoreData:(id)result{
    if([result isKindOfClass:NSDictionary.class]){
        NSArray *arr = result[@"info"];
        [LCGameListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"modelId":@"id"};
        }];
        [LCRankArchorModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"uid":@"id"};
        }];
            [self.dataArray addObjectsFromArray:[LCRankArchorModel mj_objectArrayWithKeyValuesArray:arr]];
        
    }
    return result;
}
- (void)dealWithLoadError:(NSError *)error{
    
}
- (id)dealWithLoadData:(id)result{
    if([result isKindOfClass:NSDictionary.class]){
        NSArray *arr = result[@"info"];
        [self.dataArray removeAllObjects];
        [LCGameListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"modelId":@"id"};
        }];
        [LCRankArchorModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"uid":@"id"};
        }];
            NSMutableArray *tempArr = [LCRankArchorModel mj_objectArrayWithKeyValuesArray:arr];
           
                [self.dataArray addObjectsFromArray:tempArr];
            
           
        
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
