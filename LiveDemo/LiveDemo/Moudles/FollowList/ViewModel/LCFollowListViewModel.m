//
//  LCFollowListViewModel.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/22.
//

#import "LCFollowListViewModel.h"
#import "LCFollowListApi.h"
#import "LCFollowApi.h"
@implementation LCFollowListViewModel

- (void)lc_initialize{
    [self lc_bindLoadSignal];
    [self lc_bindLoadMoreSignal];
    @weakify(self)
    [[[self.followCommand.executionSignals switchToLatest] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.followSubject sendNext:x];
    }];
    [[self.followCommand.errors takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSError * _Nullable x) {
        @strongify(self)
        [self.followSubject sendNext:x];
    }];
}
- (LCBaseApi *)getLoadApi{
   
    LCFollowListApi *api = [LCFollowListApi new];
    api.userId = self.userId;
    self.listApi = api;
    return api;
}
- (LCBaseListApi *)getPageApi{
    
    return self.listApi;
}
- (id)dealWithLoadMoreData:(id)result{
    if([result isKindOfClass:NSDictionary.class]){
        NSArray *arr = result[@"info"];
        [LCGameListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"modelId":@"id"};
        }];
        [LCRankArchorModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"uid":@"id"};
        }];
            [self.dataArray addObjectsFromArray:[LCRankArchorModel mj_objectArrayWithKeyValuesArray:arr]];
        
    }
    return result;
}
- (void)dealWithLoadError:(NSError *)error{
    
}
- (id)dealWithLoadData:(id)result{
    if([result isKindOfClass:NSDictionary.class]){
        NSArray *arr = result[@"info"];
        [self.dataArray removeAllObjects];
        [LCGameListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"modelId":@"id"};
        }];
        [LCRankArchorModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"uid":@"id"};
        }];
            NSMutableArray *tempArr = [LCRankArchorModel mj_objectArrayWithKeyValuesArray:arr];
           
                [self.dataArray addObjectsFromArray:tempArr];
            
           
        
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
- (RACCommand *)followCommand{
    if (_followCommand == nil) {
//        @weakify(self)
        _followCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(LCRankArchorModel *  _Nullable input) {
//            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                LCFollowApi *api = [[LCFollowApi alloc] init];
                api.userId = input.uid;
//                api.postId = input.postId;
                [[LCNetWorkManager manager] requestApi:api success:^(id  _Nullable result) {
                   
                    if ([result isKindOfClass:[NSDictionary class]]){
                        
                        input.isAttention = input.isAttention.boolValue?@"0":@"1";

                        [subscriber sendNext:result];
                        [subscriber sendCompleted];
                    } else{
                        [subscriber sendError:[NSError errorWithDomain:KLanguage(@"数据加载失败，请稍后再试") code:500 userInfo:nil]];
                    }
                } failure:^(NSError * _Nullable error) {
                    [subscriber sendError:error];
                }];
                    
                return [RACDisposable disposableWithBlock:^{
                    
                }];
            }];
        }];
    }
    return _followCommand;
}
- (RACSubject *)followSubject{
    if (_followSubject == nil) {
        _followSubject = [RACSubject subject];
    }
    return _followSubject;
}
@end
