//
//  LCWithDrawViewModel.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/23.
//

#import "LCWithDrawViewModel.h"
#import "LCWithDrawAccountListApi.h"
#import "LCWithDrawApi.h"
#import "LCWithDrawProfitApi.h"
@implementation LCWithDrawViewModel
- (void)lc_initialize{
    [self lc_bindLoadSignal];
   
    self.dataModel = [LCWithDrawProfitModel new];
    @weakify(self)
    [[[self.coinCountCommand.executionSignals switchToLatest] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.coinCountSubject sendNext:x];
    }];
    [[self.coinCountCommand.errors takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSError * _Nullable x) {
        @strongify(self)
        [self.coinCountSubject sendNext:x];
    }];
    [[[self.withdrawCommand.executionSignals switchToLatest] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.withdrawSubject sendNext:x];
    }];
    [[self.withdrawCommand.errors takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSError * _Nullable x) {
        @strongify(self)
        [self.withdrawSubject sendNext:x];
    }];
}
- (LCBaseApi *)getLoadApi{
    LCWithDrawAccountListApi *api = [LCWithDrawAccountListApi new];
   
    return api;
}

- (id)dealWithLoadData:(id)result{
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSArray *a = result[@"info"];
//        NSDictionary *dic = [a firstObject];
        
        [LCWithDrawAccountModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"modelId":@"id"};
        }];
        NSArray *arr = [LCWithDrawAccountModel mj_objectArrayWithKeyValuesArray:a];
        for (LCWithDrawAccountModel *model in arr) {
            if([model.type isEqualToString:self.type]){
                self.accountModel = model;
            }
        }
        if(!self.accountModel){
            self.accountModel = [LCWithDrawAccountModel new];
            self.accountModel.type = self.type;
        }
//        [WYAccountModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
//            return @{@"modelId":@"id"};
//        }];
//        [self.dataArray removeAllObjects];
//        NSArray *arr = [WYAccountModel mj_objectArrayWithKeyValuesArray:result];
//        [self.dataArray addObjectsFromArray:arr];
        
        
    }
    return result;
}
- (void)dealWithLoadError:(NSError *)error{
    
}

#pragma mark---- 懒加载 ----

- (RACCommand *)coinCountCommand{
    if (_coinCountCommand == nil) {
        @weakify(self)
        _coinCountCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id   _Nullable input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                LCWithDrawProfitApi *api = [LCWithDrawProfitApi new];

                [[LCNetWorkManager manager] requestApi:api success:^(id  _Nullable result) {
                    if ([result isKindOfClass:NSDictionary.class]){
                        NSArray *a = result[@"info"];
                        NSDictionary *dic = [a firstObject];
                        [self.dataModel mj_setKeyValues:dic];

                        [subscriber sendNext:result];
                        [subscriber sendCompleted];
                    }else{
                        [subscriber sendError:[NSError errorWithDomain:KLanguage(@"数据加载失败，请稍后再试" ) code:500 userInfo:nil]];
                    }
                } failure:^(NSError * _Nullable error) {
                    [subscriber sendError:error];
                }];

                return [RACDisposable disposableWithBlock:^{

                }];
            }];
        }];
    }
    return _coinCountCommand;
}
- (RACSubject *)coinCountSubject{
    if (_coinCountSubject== nil) {
        _coinCountSubject = [RACSubject subject];
    }
    return _coinCountSubject;
}
- (RACCommand *)withdrawCommand{
    if (_withdrawCommand == nil) {
        @weakify(self)
        _withdrawCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id    _Nullable input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                LCWithDrawApi *api = [LCWithDrawApi new];
                api.accountId = self.accountModel.modelId;
                api.money = self.money;
                [[LCNetWorkManager manager] requestApi:api success:^(id  _Nullable result) {

                        [subscriber sendNext:result];
                        [subscriber sendCompleted];

                } failure:^(NSError * _Nullable error) {
                    [subscriber sendError:error];
                }];

                return [RACDisposable disposableWithBlock:^{

                }];
            }];
        }];
    }
    return _withdrawCommand;
}
- (RACSubject *)withdrawSubject{
    if (_withdrawSubject== nil) {
        _withdrawSubject = [RACSubject subject];
    }
    return _withdrawSubject;
}

@end
