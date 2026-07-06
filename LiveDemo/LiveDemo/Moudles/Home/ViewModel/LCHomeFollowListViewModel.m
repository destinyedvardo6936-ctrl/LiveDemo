//
//  LCHomeFollowListViewModel.m
//  LiveDemo
//
//  Created by mrgao on 2022/11/23.
//

#import "LCHomeFollowListViewModel.h"
#import "LCHomeFollowLiveListApi.h"
#import "LCRecommendReplaceLiveApi.h"
@implementation LCHomeFollowListViewModel
- (void)lc_initialize{
    [self lc_bindLoadSignal];
    [self lc_bindLoadMoreSignal];
    @weakify(self)
   
    [[[self.replaceRecommendCommand.executionSignals switchToLatest] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.replaceRecommendSubject sendNext:x];
    }];
    [[self.replaceRecommendCommand.errors takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSError * _Nullable x) {
        @strongify(self)
        [self.replaceRecommendSubject sendNext:x];
    }];
    WS(weakSelf)
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:LCLoginNot object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        [weakSelf.loadDataCommend execute:@(YES)];
    }];
}
- (LCBaseApi *)getLoadApi{
    LCHomeFollowLiveListApi *api = [LCHomeFollowLiveListApi new];
    self.listApi = api;
    return api;
}
- (LCBaseListApi *)getPageApi{
    return self.listApi;
}

- (id)dealWithLoadData:(id)result{
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSArray *a  = result[@"info"];
       NSDictionary *dic = [a firstObject];
       
//        [self.bannerArray removeAllObjects];
        
        [self.dataArray removeAllObjects];
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
//        if (dic[@"slide"]){
//            [self.bannerArray addObjectsFromArray:[LCBannerModel mj_objectArrayWithKeyValuesArray:dic[@"slide"]]];
//        }
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
        NSArray *a  = result[@"info"];
       NSDictionary *dic = [a firstObject];
       
       
        if (dic[@"list"]){
            NSArray *arr = dic[@"list"];
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
- (NSMutableArray *)recommendArray{
    if (_recommendArray == nil){
        _recommendArray = [NSMutableArray array];
    }
    return _recommendArray;
}
- (RACCommand *)replaceRecommendCommand{
    if (_replaceRecommendCommand == nil){
        @weakify(self)
        _replaceRecommendCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                LCRecommendReplaceLiveApi *api = [LCRecommendReplaceLiveApi new];
                [[LCNetWorkManager manager] requestApi:api success:^(id  _Nullable result) {
                    if ([result isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *dic = result ;
                       
                       
                        if (dic[@"info"]){
                            [self.recommendArray removeAllObjects];
                            [LCGameListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                                return @{@"modelId":@"id"};
                            }];
                            NSArray *arr = [LCHomeListModel mj_objectArrayWithKeyValuesArray:dic[@"info"]];
                            
                            [self.recommendArray addObjectsFromArray:arr];
                        }
                        [subscriber sendNext:result];
                        [subscriber sendCompleted];
                        
                    }else{
                        
                        [subscriber sendError:[NSError errorWithDomain:KLanguage(@"数据加载失败，请稍后再试")  code:500 userInfo:nil]];
                    }
                  
                } failure:^(NSError * _Nullable error) {
                    [subscriber sendError:error];
                }];
   
                return [RACDisposable disposableWithBlock:^{
                    
                }];
            }];
        }];
    }
    return _replaceRecommendCommand;
}
- (RACSubject *)replaceRecommendSubject{
    if (_replaceRecommendSubject == nil){
        _replaceRecommendSubject = [RACSubject subject];
    }
    return _replaceRecommendSubject;
}
@end
