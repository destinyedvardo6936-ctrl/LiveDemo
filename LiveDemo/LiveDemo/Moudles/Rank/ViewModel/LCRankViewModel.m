//
//  LCRankViewModel.m
//  LiveDemo
//
//  Created by mrgao on 2022/11/25.
//

#import "LCRankViewModel.h"
#import "LCFollowApi.h"
#import "LCArchorRankListApi.h"
#import "LCContributionRankListApi.h"

@implementation LCRankViewModel
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
    if (self.isArchorList) {
        LCArchorRankListApi *api = [LCArchorRankListApi new];
        api.type = self.type;
        self.listApi = api;
        return api;
    }
    LCContributionRankListApi *api = [LCContributionRankListApi new];
    api.type = self.type;
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
        [LCHomeListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"uid":@"uid"};
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
        if(arr.count){
            [LCGameListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"modelId":@"id"};
            }];
            [LCHomeListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"uid":@"uid"};
            }];
           
                NSMutableArray *tempArr = [LCRankArchorModel mj_objectArrayWithKeyValuesArray:arr];
                for (LCRankArchorModel *model in tempArr) {
                    model.rankNum = [tempArr indexOfObject:model] + 1;
                }
                if(arr.count > 3){
                    [self.dataArray addObject:[tempArr subarrayWithRange:NSMakeRange(0, 3)]];
                    [self.dataArray addObjectsFromArray:[tempArr subarrayWithRange:NSMakeRange(3, tempArr.count - 3)]];
                }else{
                    [self.dataArray addObject:tempArr];
                }
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
