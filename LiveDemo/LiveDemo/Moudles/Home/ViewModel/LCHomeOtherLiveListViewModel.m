//
//  LCHomeOtherLiveListViewModel.m
//  LiveDemo
//
//  Created by mrgao on 2022/12/31.
//

#import "LCHomeOtherLiveListViewModel.h"
#import "LCHomeGameLiveListApi.h"
#import "LCHomeHotListApi.h"
#import "LCHomeGameLiveListApi.h"
#import "LCHomeRecommendListApi.h"
@implementation LCHomeOtherLiveListViewModel
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
    if ([self.currentFirstChannel isEqualToString:KLanguage(@"推荐")]){
        LCHomeRecommendListApi *api = [LCHomeRecommendListApi new];
        api.channelId = self.channelId;
        self.listApi = api;
        return self.listApi;
    }else if ([self.currentFirstChannel isEqualToString:KLanguage(@"游戏")]){
        LCHomeGameLiveListApi *api = [LCHomeGameLiveListApi new];
        api.channelId = self.channelId;
            self.listApi = api;
            return self.listApi;
        
    }
    LCHomeHotListApi *api = [LCHomeHotListApi new];
    api.channelId = self.channelId;
    self.listApi = api;
    return self.listApi;
    
}
/// 翻页api
- (LCBaseListApi *)getPageApi{
    return self.listApi;
}



- (id)dealWithLoadData:(id)result{
    if([self.listApi isKindOfClass:[LCHomeRecommendListApi class]]){
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = result[@"info"];
            [self.dataArray removeAllObjects];
            
            [self.bannerArray removeAllObjects];
            
            
            NSArray *list = dic[@"list"];
            
            [LCGameListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"modelId":@"id"};
            }];
            [LCHomeListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"uid":@"uid"};
            }];
            
                
                NSArray *arr = [LCHomeListModel mj_objectArrayWithKeyValuesArray:list];
            [self.dataArray addObjectsFromArray:arr];
                
    //            [self.dataArray addObjectsFromArray:[LCHomeRecommendModel mj_objectArrayWithKeyValuesArray:dic[@"list"]]];
            
       
            
            if (dic[@"slide"]){
                [self.bannerArray addObjectsFromArray:[LCBannerModel mj_objectArrayWithKeyValuesArray:dic[@"slide"]]];
            }
            
            
            
        }
      
    }else{
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSArray *a = result[@"info"];
            NSDictionary *dic = [a firstObject];
           
            [self.bannerArray removeAllObjects];
            
            [self.dataArray removeAllObjects];
            if (dic[@"list"]){
                [LCGameListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                    return @{@"modelId":@"id"};
                }];
                NSArray *arr = [LCHomeListModel mj_objectArrayWithKeyValuesArray:dic[@"list"]];
                
                [self.dataArray addObjectsFromArray:arr];
            }
            if (dic[@"slide"]){
                [self.bannerArray addObjectsFromArray:[LCBannerModel mj_objectArrayWithKeyValuesArray:dic[@"slide"]]];
            }
    //        if (dic[@"recommend"]){
    //            [self.recommendArchorArray addObjectsFromArray:[LCRecommendArchorModel mj_objectArrayWithKeyValuesArray:dic[@"recommend"]]];
    //        }
            
            
        }
      
    }
    
    
    return result;
}

- (void)dealWithLoadError:(NSError *)error{
    
}
- (id)dealWithLoadMoreData:(id)result{
    if([self.listApi isKindOfClass:[LCHomeRecommendListApi class]]){
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = result[@"info"];
           
            
            NSArray *list = dic[@"list"];
            
            [LCGameListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"modelId":@"id"};
            }];
            [LCHomeListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"uid":@"uid"};
            }];
            
                
                NSArray *arr = [LCHomeListModel mj_objectArrayWithKeyValuesArray:list];
            [self.dataArray addObjectsFromArray:arr];
                

            
        }
      
    }else{
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSArray *a  = result[@"info"];
           NSDictionary *dic = [a firstObject];
           
            if (dic[@"list"]){
                [LCGameListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                    return @{@"modelId":@"id"};
                }];
                [LCHomeListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                    return @{@"uid":@"uid"};
                }];
                NSArray *arr = [LCHomeListModel mj_objectArrayWithKeyValuesArray:dic[@"list"]];
                
                [self.dataArray addObjectsFromArray:arr];
            }
           
            
            
        }
    }
    
  
    
    return result;
    
}
- (void)dealWithLoadMoreError:(NSError *)error{
    
}
- (BOOL)dealWithNoPageWithData:(id)result{
    if([self.listApi isKindOfClass:[LCHomeRecommendListApi class]]){
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = result[@"info"];
           
            
            NSArray *list = dic[@"list"];
            
            if (dic[@"list"]){
                NSArray *arr = dic[@"list"];
                return arr.count ? NO : YES;
            }
                

            
        }
      
    }else{
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSArray *a  = result[@"info"];
           NSDictionary *dic = [a firstObject];
           
           
            if (dic[@"list"]){
                NSArray *arr = dic[@"list"];
                return arr.count ? NO : YES;
            }
            
            
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
