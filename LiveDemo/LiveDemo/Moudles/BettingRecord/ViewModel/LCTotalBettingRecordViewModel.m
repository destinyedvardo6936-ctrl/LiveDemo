//
//  LCBettingRecordViewModel.m
//  LiveDemo
//
//  Created by mrgao on 2023/5/9.
//

#import "LCTotalBettingRecordViewModel.h"
#import "LCTotalBettingRecordListApi.h"
#import "LCTotalBCBettingRecordListApi.h"
@implementation LCTotalBettingRecordViewModel
- (void)lc_initialize{
    [self lc_bindLoadSignal];
    [self lc_bindLoadMoreSignal];
  
}
- (LCBaseApi *)getLoadApi{
    if(self.isBc){
        LCTotalBCBettingRecordListApi *api = [LCTotalBCBettingRecordListApi new];
        self.listApi = api;
        return api;
    }
    LCTotalBettingRecordListApi *api = [LCTotalBettingRecordListApi new];
    
    self.listApi = api;
    return api;
}
- (LCBaseListApi *)getPageApi{
    
    return self.listApi;
}
- (id)dealWithLoadMoreData:(id)result{
    if(self.isBc){
        return result;
    }else{
        if([result isKindOfClass:NSDictionary.class]){
            NSArray *arr = result[@"info"];
            [LCBettingRecordModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"modelId":@"id"};
            }];
                [self.dataArray addObjectsFromArray:[LCBettingRecordModel mj_objectArrayWithKeyValuesArray:arr]];
            
        }
        return result;
    }
    
}
- (void)dealWithLoadError:(NSError *)error{
    
}
- (id)dealWithLoadData:(id)result{
    if(self.isBc){
        return result;
    }else{
        if([result isKindOfClass:NSDictionary.class]){
            NSArray *arr = result[@"info"];
            [LCBettingRecordModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"modelId":@"id"};
            }];
                [self.dataArray addObjectsFromArray:[LCBettingRecordModel mj_objectArrayWithKeyValuesArray:arr]];
            
        }
        return result;
    }
   
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
