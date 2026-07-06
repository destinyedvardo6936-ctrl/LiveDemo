//
//  LCRechargeRecordViewModel.m
//  LiveDemo
//
//  Created by mrgao on 2023/6/8.
//

#import "LCRechargeRecordViewModel.h"
#import "LCRechargeRecordListApi.h"
@implementation LCRechargeRecordViewModel
- (void)lc_initialize{
    [self lc_bindLoadSignal];
    [self lc_bindLoadMoreSignal];
    
}
- (LCBaseApi *)getLoadApi{
   
    LCRechargeRecordListApi *api = [LCRechargeRecordListApi new];
   
    self.listApi = api;
    return api;
}
- (LCBaseListApi *)getPageApi{
    
    return self.listApi;
}
- (id)dealWithLoadMoreData:(id)result{
    if([result isKindOfClass:NSDictionary.class]){
        NSArray *arr = result[@"info"];
        [LCRechargeRecordModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"modelId":@"id"};
        }];
       
            [self.dataArray addObjectsFromArray:[LCRechargeRecordModel mj_objectArrayWithKeyValuesArray:arr]];
        
    }
    return result;
}
- (void)dealWithLoadError:(NSError *)error{
    
}
- (id)dealWithLoadData:(id)result{
    if([result isKindOfClass:NSDictionary.class]){
        NSArray *arr = result[@"info"];
        [self.dataArray removeAllObjects];
        [LCRechargeRecordModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"modelId":@"id"};
        }];
       
            [self.dataArray addObjectsFromArray:[LCRechargeRecordModel mj_objectArrayWithKeyValuesArray:arr]];
            
           
        
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
