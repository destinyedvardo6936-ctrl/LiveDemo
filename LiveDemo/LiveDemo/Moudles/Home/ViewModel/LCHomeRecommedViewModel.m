//
//  LCHomeRecommedViewModel.m
//  liveCommon
//
//  Created by mrgao on 2022/9/30.
//

#import "LCHomeRecommedViewModel.h"
#import "LCHomeRecommendListApi.h"
#import "LCHomeSegmentsApi.h"
#import "LCRecommendArchorModel.h"

@implementation LCHomeRecommedViewModel
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
//    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:LCLiveNeedLastPage object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
//        [weakSelf.loadDataCommend execute:@(YES)];
//    }];
//    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:LCLiveNeedNextPage object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
//        [weakSelf.nextPageCommand execute:@(YES)];
//    }];
}

/// load api
- (LCBaseApi *)getLoadApi{
    
    LCHomeRecommendListApi *api = [LCHomeRecommendListApi new];
    
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
        [self.topDataArray removeAllObjects];
        [self.bottomDataArray removeAllObjects];
        [self.bannerArray removeAllObjects];
        [self.recommendArchorArray removeAllObjects];
        [self.gameRecommendArchorArray removeAllObjects];
        
        NSArray *list = dic[@"list"];
        NSArray *gameList = dic[@"gametj"];
        NSArray *gnList = dic[@"twotuijian"];
        [LCGameListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"modelId":@"id"};
        }];
        [LCHomeListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"uid":@"uid"};
        }];
//        [[NSNotificationCenter defaultCenter]postNotificationName:LCLiveHasLoadNextPage object:[LCHomeListModel mj_objectArrayWithKeyValuesArray:list]];
        if (list.count){
            
            NSArray *arr = [LCHomeListModel mj_objectArrayWithKeyValuesArray:list];
            if (arr.count > 4){
                [self.topDataArray addObjectsFromArray:[arr subarrayWithRange:NSMakeRange(0, 4)]];
                [self.bottomDataArray addObjectsFromArray:[arr subarrayWithRange:NSMakeRange(4, arr.count - 4)]];
            }else{
                if(arr.count){
                    [self.topDataArray addObjectsFromArray:arr];
                }
            }
            
//            [self.dataArray addObjectsFromArray:[LCHomeRecommendModel mj_objectArrayWithKeyValuesArray:dic[@"list"]]];
        }
        if(gameList.count){
            [self.gameRecommendArchorArray addObjectsFromArray:[LCHomeListModel mj_objectArrayWithKeyValuesArray:gameList]];
        }
        if(gnList.count){
            [self.recommendArchorArray addObjectsFromArray:[LCHomeListModel mj_objectArrayWithKeyValuesArray:gnList]];
        }
        
        if (dic[@"slide"]){
            [self.bannerArray addObjectsFromArray:[LCBannerModel mj_objectArrayWithKeyValuesArray:dic[@"slide"]]];
        }
        
        
        
    }
  
    
    return result;
}

- (void)dealWithLoadError:(NSError *)error{
    
}
- (id)dealWithLoadMoreData:(id)result{
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = result[@"info"];
       
        if (dic[@"list"]){
            if(self.topDataArray.count == 4){
                [LCGameListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                    return @{@"modelId":@"id"};
                }];
                [LCHomeListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                    return @{@"uid":@"uid"};
                }];
                [self.bottomDataArray addObjectsFromArray:[LCHomeListModel mj_objectArrayWithKeyValuesArray:dic[@"list"]]];
//                [[NSNotificationCenter defaultCenter]postNotificationName:LCLiveHasLoadNextPage object:[LCHomeListModel mj_objectArrayWithKeyValuesArray:dic[@"list"]]];
            }
           
        }
       
        
        
    }
    
    return result;
    
}
- (void)dealWithLoadMoreError:(NSError *)error{
    
}
- (BOOL)dealWithNoPageWithData:(id)result{
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = result[@"info"];
       
       
        if (dic[@"list"]){
            NSArray *arr = dic[@"list"];
            return arr.count ? NO : YES;
        }
        
        
    }
    return NO;
}

#pragma mark---- 懒加载 ----
//- (NSMutableArray *)dataArray{
//    if (_dataArray == nil) {
//        _dataArray = [NSMutableArray array];
//    }
//    return _dataArray;
//}
- (NSMutableArray *)bannerArray{
    if (_bannerArray == nil) {
        _bannerArray = [NSMutableArray array];
    }
    return _bannerArray;
}
- (NSMutableArray *)recommendArchorArray{
    if (_recommendArchorArray == nil) {
        _recommendArchorArray = [NSMutableArray array];
    }
    return _recommendArchorArray;
}

- (NSMutableArray *)topDataArray{
    if (_topDataArray == nil){
        _topDataArray = [NSMutableArray array];
    }
    return _topDataArray;
}
- (NSMutableArray *)bottomDataArray{
    if (_bottomDataArray == nil){
        _bottomDataArray = [NSMutableArray array];
    }
    return _bottomDataArray;
}
- (NSMutableArray *)gameRecommendArchorArray{
    if (_gameRecommendArchorArray == nil){
        _gameRecommendArchorArray = [NSMutableArray array];
    }
    return _gameRecommendArchorArray;
}

@end
