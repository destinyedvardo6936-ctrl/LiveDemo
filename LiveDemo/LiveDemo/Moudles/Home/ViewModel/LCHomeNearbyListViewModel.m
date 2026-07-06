//
//  LCHomeNearbyListViewModel.m
//  LiveDemo
//
//  Created by mrgao on 2022/11/23.
//

#import "LCHomeNearbyListViewModel.h"
#import "LCHomeNearbyListApi.h"
@implementation LCHomeNearbyListViewModel
/**
 *  初始化
 */
- (void)lc_initialize{
    [self lc_bindLoadSignal];
    [self lc_bindLoadMoreSignal];
    WS(weakSelf)
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:LCLoginNot object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        [weakSelf.loadDataCommend execute:@(YES)];
    }];
}

/// load api
- (LCBaseApi *)getLoadApi{
   
    LCHomeNearbyListApi *api = [LCHomeNearbyListApi new];

        self.listApi = api;
        return self.listApi;
    
}
/// 翻页api
- (LCBaseListApi *)getPageApi{
    return self.listApi;
}



- (id)dealWithLoadData:(id)result{
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = result[@"info"];
       
        [self.bannerArray removeAllObjects];
        
        [self.dataArray removeAllObjects];
        if ([dic isKindOfClass:NSDictionary.class] && dic[@"list"]){
            [LCGameListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"modelId":@"id"};
            }];
            NSArray *arr = [LCHomeListModel mj_objectArrayWithKeyValuesArray:dic[@"list"]];
            
            [self.dataArray addObjectsFromArray:arr];
        }
        if ([dic isKindOfClass:NSDictionary.class] &&dic[@"slide"]){
            [self.bannerArray addObjectsFromArray:[LCBannerModel mj_objectArrayWithKeyValuesArray:dic[@"slide"]]];
        }
//        if (dic[@"recommend"]){
//            [self.recommendArchorArray addObjectsFromArray:[LCRecommendArchorModel mj_objectArrayWithKeyValuesArray:dic[@"recommend"]]];
//        }
        
        
    }
  
    
    return result;
}

- (void)dealWithLoadError:(NSError *)error{
    
}
- (id)dealWithLoadMoreData:(id)result{
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = result[@"info"];
       
       
        if ([dic isKindOfClass:NSDictionary.class] &&dic[@"list"]){
            [LCGameListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"modelId":@"id"};
            }];
            NSArray *arr = [LCHomeListModel mj_objectArrayWithKeyValuesArray:dic[@"list"]];
            
            [self.dataArray addObjectsFromArray:arr];
        }
        if ([dic isKindOfClass:NSDictionary.class] &&dic[@"slide"]){
            [self.bannerArray addObjectsFromArray:[LCBannerModel mj_objectArrayWithKeyValuesArray:dic[@"slide"]]];
        }
//        if (dic[@"recommend"]){
//            [self.recommendArchorArray addObjectsFromArray:[LCRecommendArchorModel mj_objectArrayWithKeyValuesArray:dic[@"recommend"]]];
//        }
        
        
    }
  
    
    return result;
    
}
- (void)dealWithLoadMoreError:(NSError *)error{
    
}
- (BOOL)dealWithNoPageWithData:(id)result{
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = result[@"info"];
       
       
        if ([dic isKindOfClass:NSDictionary.class] &&dic[@"list"]){
            NSArray *arr = dic[@"list"];
            return arr.count ? NO : YES;
        }
        
        
    }
    return NO;
}

#pragma mark---- 懒加载 ----

- (NSMutableArray *)bannerArray{
    if (_bannerArray == nil) {
        _bannerArray = [NSMutableArray array];
    }
    return _bannerArray;
}
- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
