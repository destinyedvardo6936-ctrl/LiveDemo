//
//  LCMyBackPackViewModel.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/15.
//

#import "LCMyBackPackViewModel.h"
#import "LCMyBackPackApi.h"
@implementation LCMyBackPackViewModel
- (void)lc_initialize{
    [self lc_bindLoadSignal];
    [self lc_bindLoadMoreSignal];
}
- (LCBaseApi *)getLoadApi{
    LCMyBackPackApi *api = [LCMyBackPackApi new];
   
    self.listApi = api;
    return api;
 
}
- (LCBaseListApi *)getPageApi{
    return self.listApi;
}

- (id)dealWithLoadData:(id)result{
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = result ;

        NSArray *info = dic[@"info"];
        NSDictionary *subDic= [info firstObject];
        
        if (subDic[@"giftlist"]){
            
            [self.dataArray removeAllObjects];
            [LCMyBackPackModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"modelId":@"id"};
            }];
            NSArray *arr = [LCMyBackPackModel mj_objectArrayWithKeyValuesArray:subDic[@"giftlist"]];
          
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
        
            [LCMyBackPackModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"modelId":@"id"};
            }];
            NSArray *arr = [LCMyBackPackModel mj_objectArrayWithKeyValuesArray:dic[@"info"]];

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
