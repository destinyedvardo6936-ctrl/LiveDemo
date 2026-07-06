//
//  LCSearchViewModel.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/2.
//

#import "LCSearchViewModel.h"
#import "LCSearchApi.h"
@implementation LCSearchViewModel
- (void)lc_initialize{
    [self lc_bindLoadSignal];
    [self lc_bindLoadMoreSignal];
}
- (LCBaseApi *)getLoadApi{
   
    LCSearchApi *api = [LCSearchApi new];
        api.searchText = self.searchText;
        self.listApi = api;
        return api;
    
 
}
- (LCBaseListApi *)getPageApi{
    
    return self.listApi;
}

- (id)dealWithLoadData:(id)result{
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = result ;
       
        [LCGameListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"modelId":@"id"};
        }];
        [LCHomeListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"uid":@"uid"};
        }];
        
        [self.dataArray removeAllObjects];
        if (dic[@"info"]){
            [LCRankArchorModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"uid":@"id"};
            }];
            NSArray *arr = [LCRankArchorModel mj_objectArrayWithKeyValuesArray:dic[@"info"]];
            
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
       
        [LCGameListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"modelId":@"id"};
        }];
        [LCHomeListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"uid":@"uid"};
        }];
        if (dic[@"info"]){
            [LCRankArchorModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"uid":@"id"};
            }];
            NSArray *arr = [LCRankArchorModel mj_objectArrayWithKeyValuesArray:dic[@"info"]];
            
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
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
