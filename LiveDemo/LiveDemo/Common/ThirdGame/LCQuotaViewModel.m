//
//  LCQuotaViewModel.m
//  LiveDemo
//
//  Created by mrgao on 2023/5/10.
//

#import "LCQuotaViewModel.h"
#import "LCQuotaGameLisApi.h"
#import "LCQuatoBalanceApi.h"
#import "LCQuotaTransApi.h"
#import "LCMyWalletApi.h"
@implementation LCQuotaViewModel
- (void)lc_initialize{
    [self lc_bindLoadSignal];
    [self lc_bindLoadMoreSignal];
    @weakify(self)
    [[[self.balanceCommand.executionSignals switchToLatest] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.balanceSubject sendNext:x];
    }];
    [[self.balanceCommand.errors takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSError * _Nullable x) {
        @strongify(self)
        [self.balanceSubject sendNext:x];
    }];
    [[[self.gameBalanceCommand.executionSignals switchToLatest] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.gameBalanceSubject sendNext:x];
    }];
    [[self.gameBalanceCommand.errors takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSError * _Nullable x) {
        @strongify(self)
        [self.gameBalanceSubject sendNext:x];
    }];
    [[[self.gameTransInCommand.executionSignals switchToLatest] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.gameTransInSubject sendNext:x];
    }];
    [[self.gameTransInCommand.errors takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSError * _Nullable x) {
        @strongify(self)
        [self.gameTransInSubject sendNext:x];
    }];
    [[[self.gameTransOutCommand.executionSignals switchToLatest] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.gameTransOutSubject sendNext:x];
    }];
    [[self.gameTransOutCommand.errors takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSError * _Nullable x) {
        @strongify(self)
        [self.gameTransOutSubject sendNext:x];
    }];
    
}
- (LCBaseApi *)getLoadApi{
    LCQuotaGameLisApi *api = [LCQuotaGameLisApi new];
    self.listApi = api;
    return api;
}
- (LCBaseListApi *)getPageApi{
    return self.listApi;
}

- (id)dealWithLoadData:(id)result{
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSArray *a  = result[@"info"];
      
       
//        [self.bannerArray removeAllObjects];
        
        [self.dataArray removeAllObjects];
       
       
            NSArray *arr = [LCQuotaModel mj_objectArrayWithKeyValuesArray:a];
            
            [self.dataArray addObjectsFromArray:arr];
        

        
        
    }
  
    
    return result;
}

- (void)dealWithLoadError:(NSError *)error{
    
}
- (id)dealWithLoadMoreData:(id)result{
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSArray *a  = result[@"info"];
      

        
        
       
       
            NSArray *arr = [LCQuotaModel mj_objectArrayWithKeyValuesArray:a];
            
            [self.dataArray addObjectsFromArray:arr];
        

        
        
    }
  
    
    return result;
    
}
- (void)dealWithLoadMoreError:(NSError *)error{
    
}
- (BOOL)dealWithNoPageWithData:(id)result{
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSArray *a  = result[@"info"];
      
            return a.count ? NO : YES;
        
        
        
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

- (RACCommand *)balanceCommand{
    if (_balanceCommand == nil){
        @weakify(self)
        _balanceCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                LCMyWalletApi *api = [LCMyWalletApi new];
                
                [[LCNetWorkManager manager] requestApi:api success:^(id  _Nullable result) {
                    if([result isKindOfClass:NSDictionary.class]){
                        NSArray *a = result[@"info"];
                        NSDictionary *dic = [a firstObject];
                        self.balanceStr = [NSString stringWithFormat:@"%ld",[dic[@"coin"]integerValue]];
                        LCUserInfoModel *model = [LCUserInfoManager shareManager].userInfo;
                        model.coin = self.balanceStr;
                        [[LCUserInfoManager shareManager] updateUserInfo:model];
                    }
                    [subscriber sendNext:input];
                    [subscriber sendCompleted];
                } failure:^(NSError * _Nullable error) {
                    [subscriber sendError:error];
                }];
               
                return [RACDisposable disposableWithBlock:^{
                    
                }];
            }];
        }];
    }
    return _balanceCommand;
}
- (RACSubject *)balanceSubject{
    if (_balanceSubject == nil){
        _balanceSubject = [RACSubject subject];
    }
    return _balanceSubject;
}
- (RACCommand *)gameBalanceCommand{
    if (_gameBalanceCommand == nil){
        @weakify(self)
        _gameBalanceCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(LCQuotaModel *  _Nullable input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                LCQuatoBalanceApi *api = [LCQuatoBalanceApi new];
                api.type = input.type;
                api.code = input.code;
                api.biaoshi = input.biaoshi;
                [[LCNetWorkManager manager] requestApi:api success:^(id  _Nullable result) {
                    if ([result isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *dic = result[@"info"] ;
                       
                       
                        if (dic[@"balance"]){
                            input.balance = minstr(dic[@"balance"]);
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
    return _gameBalanceCommand;
}
- (RACSubject *)gameBalanceSubject{
    if (_gameBalanceSubject == nil){
        _gameBalanceSubject = [RACSubject subject];
    }
    return _gameBalanceSubject;
}
- (RACCommand *)gameTransInCommand{
    if (_gameTransInCommand == nil){
        @weakify(self)
        _gameTransInCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(RACTuple *  _Nullable input) {
            LCQuotaModel *model = input[0];
            NSString *amount = input[1];
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                LCQuotaTransApi *api = [LCQuotaTransApi new];
                api.biaoshi = model.biaoshi;
                api.action = @"0";
                api.amount = amount;
                [[LCNetWorkManager manager] requestApi:api success:^(id  _Nullable result) {
                    if ([result isKindOfClass:[NSDictionary class]]) {
                        
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
    return _gameTransInCommand;
}
- (RACSubject *)gameTransInSubject{
    if (_gameTransInSubject == nil){
        _gameTransInSubject = [RACSubject subject];
    }
    return _gameTransInSubject;
}
- (RACCommand *)gameTransOutCommand{
    if (_gameTransOutCommand == nil){
        @weakify(self)
        _gameTransOutCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(RACTuple *  _Nullable input) {
            LCQuotaModel *model = input[0];
            NSString *amount = input[1];
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                LCQuotaTransApi *api = [LCQuotaTransApi new];
                api.biaoshi = model.biaoshi;
                api.action = @"1";
                api.amount = amount;
                [[LCNetWorkManager manager] requestApi:api success:^(id  _Nullable result) {
                    if ([result isKindOfClass:[NSDictionary class]]) {
                        
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
    return _gameTransOutCommand;
}
- (RACSubject *)gameTransOutSubject{
    if (_gameTransOutSubject == nil){
        _gameTransOutSubject = [RACSubject subject];
    }
    return _gameTransOutSubject;
}
@end
