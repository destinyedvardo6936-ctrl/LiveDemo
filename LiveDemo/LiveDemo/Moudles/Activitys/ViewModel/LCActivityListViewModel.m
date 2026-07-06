//
//  LCActivityListViewModel.m
//  LiveDemo
//
//  Created by mrgao on 2023/1/3.
//

#import "LCActivityListViewModel.h"
#import "LCActivityListApi.h"
@implementation LCActivityListViewModel
- (void)lc_initialize{
    [self lc_bindLoadSignal];
    [self lc_bindLoadMoreSignal];
}
- (LCBaseApi *)getLoadApi{
    LCActivityListApi *api = [LCActivityListApi new];
    api.type = self.dataModel.type;
    self.listApi = api;
    return api;
}
- (LCBaseListApi *)getPageApi{
    return self.listApi;
}

- (id)dealWithLoadData:(id)result{
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = result ;

        
        if (dic[@"info"]){
            [self.dataArray removeAllObjects];
            [LCActivityModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"modelId":@"id"};
            }];
            NSArray *arr = [LCActivityModel mj_objectArrayWithKeyValuesArray:dic[@"info"]];

            [self.dataArray addObjectsFromArray:arr];
        }

        
        
    }
  
    
    return result;
}

- (void)dealWithLoadError:(NSError *)error{
    
}
- (id)dealWithLoadMoreData:(id)result{
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = result ;
       
       
        if (dic[@"info"]){
        
            [LCActivityModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"modelId":@"id"};
            }];
            NSArray *arr = [LCActivityModel mj_objectArrayWithKeyValuesArray:dic[@"info"]];

            [self.dataArray addObjectsFromArray:arr];
        }
        
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
    if (_dataArray == nil){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
