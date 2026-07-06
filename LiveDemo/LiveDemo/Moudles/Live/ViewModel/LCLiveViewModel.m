//
//  LCLiveViewModel.m
//  LiveDemo
//
//  Created by mrgao on 2022/11/26.
//

#import "LCLiveViewModel.h"
#import "LCRecommendReplaceLiveApi.h"
@implementation LCLiveViewModel
- (void)lc_initialize{
    WS(weakSelf);
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:LCLiveHasLoadLastPage object:nil]takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        NSArray *nextArr = x.object;
        if(nextArr.count){
            NSArray *temp = [nextArr mj_JSONObject];
            [LCHomeListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                
                return @{@"uid":@"id"};
            }];
            [LCGameListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"modelId":@"id"};
            }];
            NSArray *arr = [LCHomeListModel mj_objectArrayWithKeyValuesArray:temp];
            [weakSelf.dataArray insertObjects:arr atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, arr.count)]];
            [weakSelf.lastLivePageSubject sendNext:@(arr.count)];
        }else{
            LCRecommendReplaceLiveApi *api = [LCRecommendReplaceLiveApi new];
            [[LCNetWorkManager manager] requestApi:api success:^(id  _Nullable result) {
                if ([result isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *dic = result ;
                   
                   
                    if (dic[@"info"]){
                        
                        [LCGameListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                            return @{@"modelId":@"id"};
                        }];
                        NSArray *arr = [LCHomeListModel mj_objectArrayWithKeyValuesArray:dic[@"info"]];
                        
                        [weakSelf.dataArray insertObjects:arr atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, arr.count)]];
                        [weakSelf.lastLivePageSubject sendNext:@(arr.count)];
                    }else{
                        [weakSelf.lastLivePageSubject sendNext:@(0)];
                    }
                    
                    
                }else{
                    
                    [weakSelf.lastLivePageSubject sendNext:@(0)];
                }
              
            } failure:^(NSError * _Nullable error) {
                [weakSelf.lastLivePageSubject sendNext:@(0)];
            }];
            
        }
        
    }];
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:LCLiveHasLoadNextPage object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        NSArray *nextArr = x.object;
        if(nextArr.count){
            NSArray *temp = [nextArr mj_JSONObject];
            [LCHomeListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                
                return @{@"uid":@"id"};
            }];
            [LCGameListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"modelId":@"id"};
            }];
            NSArray *arr = [LCHomeListModel mj_objectArrayWithKeyValuesArray:temp];
            [weakSelf.dataArray addObjectsFromArray:arr];
            [weakSelf.nextLivePageSubject sendNext:@(arr.count)];
        }else{
            LCRecommendReplaceLiveApi *api = [LCRecommendReplaceLiveApi new];
            [[LCNetWorkManager manager] requestApi:api success:^(id  _Nullable result) {
                if ([result isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *dic = result ;
                   
                   
                    if (dic[@"info"]){
                        
                        [LCGameListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                            return @{@"modelId":@"id"};
                        }];
                        NSArray *arr = [LCHomeListModel mj_objectArrayWithKeyValuesArray:dic[@"info"]];
                        
                        [weakSelf.dataArray addObjectsFromArray:arr];
                        [weakSelf.nextLivePageSubject sendNext:@(arr.count)];
                    }else{
                        [weakSelf.nextLivePageSubject sendNext:@(0)];
                    }
                    
                    
                }else{
                    
                    [weakSelf.nextLivePageSubject sendNext:@(0)];
                }
              
            } failure:^(NSError * _Nullable error) {
                [weakSelf.nextLivePageSubject sendNext:@(0)];
            }];
            
        }
    }];
}

- (void)setOrigalArr:(NSArray *)origalArr{
    _origalArr = origalArr;
    NSArray *temp = [_origalArr mj_JSONObject];
//    [LCHomeListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
//        
//        return @{@"uid":@"id"};
//    }];
    [LCGameListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"modelId":@"id"};
    }];
    [self.dataArray addObjectsFromArray:[LCHomeListModel mj_objectArrayWithKeyValuesArray:temp]];

}
#pragma mark---- 懒加载 ----
- (NSMutableArray *)dataArray{
    if (!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (RACCommand *)nextLivePageCommand{
    if(!_nextLivePageCommand){
        @weakify(self)
        _nextLivePageCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//                [[NSNotificationCenter defaultCenter]postNotificationName:LCLiveNeedNextPage object:nil];
                
                LCRecommendReplaceLiveApi *api = [LCRecommendReplaceLiveApi new];
                [[LCNetWorkManager manager] requestApi:api success:^(id  _Nullable result) {
                    if ([result isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *dic = result ;
                       
                       
                        if (dic[@"info"]){
                            
                            [LCGameListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                                return @{@"modelId":@"id"};
                            }];
                            [LCHomeListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                                
                                return @{@"uid":@"uid"};
                            }];
                            NSArray *arr = [LCHomeListModel mj_objectArrayWithKeyValuesArray:dic[@"info"]];
                            
                            [self.dataArray addObjectsFromArray:arr];
                            NSMutableIndexSet *indexPathArr = [[NSMutableIndexSet alloc] init];
                            for (LCHomeListModel *m in arr) {
                                [indexPathArr addIndex:[self.dataArray indexOfObject:m]];
                               
                            }
//
                            
                            [self.nextLivePageSubject sendNext:indexPathArr];
                        }else{
                            [self.nextLivePageSubject sendNext:nil];
                        }
                        [subscriber sendNext:input];
                        [subscriber sendCompleted];
                        
                    }else{
                        
                        [self.nextLivePageSubject sendNext:[NSError errorWithDomain:KLanguage(@"数据加载失败，请稍后再试") code:500 userInfo:nil]];
                        [subscriber sendError:[NSError errorWithDomain:KLanguage(@"数据加载失败，请稍后再试") code:500 userInfo:nil]];
                    }
                  
                } failure:^(NSError * _Nullable error) {
                    [self.nextLivePageSubject sendNext:error];
                    [subscriber sendError:error];
                }];
                
                return [RACDisposable disposableWithBlock:^{
                    
                }];
            }];
        }];
    }
    return _nextLivePageCommand;
}
- (RACSubject *)nextLivePageSubject{
    if(!_nextLivePageSubject){
        _nextLivePageSubject = [RACSubject subject];
    }
    return _nextLivePageSubject;
}
- (RACCommand *)lastLivePageCommand{
    if(!_lastLivePageCommand){
        @weakify(self)
        _lastLivePageCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//                [[NSNotificationCenter defaultCenter]postNotificationName:LCLiveNeedLastPage object:nil];
                LCRecommendReplaceLiveApi *api = [LCRecommendReplaceLiveApi new];
                [[LCNetWorkManager manager] requestApi:api success:^(id  _Nullable result) {
                    if ([result isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *dic = result ;
                       
                       
                        if (dic[@"info"]){
                            
                            [LCGameListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                                return @{@"modelId":@"id"};
                            }];
                            [LCHomeListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                                
                                return @{@"uid":@"uid"};
                            }];
                            NSArray *arr = [LCHomeListModel mj_objectArrayWithKeyValuesArray:dic[@"info"]];
                            
                            [self.dataArray insertObjects:arr atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, arr.count)]];
                            NSMutableIndexSet *indexPathArr = [[NSMutableIndexSet alloc] init];
                            for (LCHomeListModel *m in arr) {
                                [indexPathArr addIndex:[self.dataArray indexOfObject:m]];
                               
                            }
                            
                            [self.lastLivePageSubject sendNext:indexPathArr];
                        }else{
                            [self.lastLivePageSubject sendNext:nil];
                        }
                        [subscriber sendNext:input];
                        [subscriber sendCompleted];
                        
                    }else{
                        
                        [self.lastLivePageSubject sendNext:[NSError errorWithDomain:KLanguage(@"数据加载失败，请稍后再试") code:500 userInfo:nil]];
                        [subscriber sendError:[NSError errorWithDomain:KLanguage(@"数据加载失败，请稍后再试") code:500 userInfo:nil]];
                    }
                  
                } failure:^(NSError * _Nullable error) {
                    [self.lastLivePageSubject sendNext:error];
                    [subscriber sendError:error];
                }];
                
//                [subscriber sendNext:input];
//                [subscriber sendCompleted];
                return [RACDisposable disposableWithBlock:^{
                    
                }];
            }];
        }];
    }
    return _lastLivePageCommand;
}
- (RACSubject *)lastLivePageSubject{
    if(!_lastLivePageSubject){
        _lastLivePageSubject = [RACSubject subject];
    }
    return _lastLivePageSubject;
}
@end
