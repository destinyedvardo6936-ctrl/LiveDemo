//
//  LCWithDrawBindAccountViewModel.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/23.
//

#import "LCWithDrawBindAccountViewModel.h"
#import "LCWithDrawAddAcountApi.h"
#import "LCWithDrawDeleteAccountApi.h"

@implementation LCWithDrawBindAccountViewModel
- (void)lc_initialize{
    @weakify(self)
    
    [[[self.addAccountCommand.executionSignals switchToLatest] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.addAccountSubject sendNext:x];
    }];
    [[self.addAccountCommand.errors takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSError * _Nullable x) {
        @strongify(self)
        [self.addAccountSubject sendNext:x];
    }];
}
#pragma mark---- 懒加载 ----
- (RACCommand *)addAccountCommand{
    if (_addAccountCommand == nil) {
      WS(weakSelf)
        
        _addAccountCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id   _Nullable input) {
            
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                if(weakSelf.dataModel.modelId.length){
                    LCWithDrawDeleteAccountApi *deleteApi = [LCWithDrawDeleteAccountApi new];
                    deleteApi.accountId = weakSelf.dataModel.modelId;
                    [[LCNetWorkManager manager] requestApi:deleteApi success:^(id  _Nullable result) {
                        if ([result isKindOfClass:NSDictionary.class]){
                            LCWithDrawAddAcountApi *api = [LCWithDrawAddAcountApi new];
                            api.type = weakSelf.dataModel.type;
                            api.name = weakSelf.dataModel.name;
                            api.account = weakSelf.dataModel.account;
                            api.account_bank = weakSelf.dataModel.account_bank;
                            [[LCNetWorkManager manager]requestApi:api success:^(id  _Nullable result1) {
                                if([result1 isKindOfClass:NSDictionary.class]){
                                    [subscriber sendNext:result1];
                                    [subscriber sendCompleted];
                                    
                                }else{
                                    [subscriber sendError:[NSError errorWithDomain:KLanguage(@"数据加载失败，请稍后再试" ) code:500 userInfo:nil]];
                                }
                                                        } failure:^(NSError * _Nullable error1) {
                                                            [subscriber sendError:error1];
                                                        }];

                           
                        }else{
                            [subscriber sendError:[NSError errorWithDomain:KLanguage(@"数据加载失败，请稍后再试" ) code:500 userInfo:nil]];
                        }
                    } failure:^(NSError * _Nullable error) {
                        [subscriber sendError:error];
                    }];
                }else{
                    LCWithDrawAddAcountApi *api = [LCWithDrawAddAcountApi new];
                    api.type = weakSelf.dataModel.type;
                    api.name = weakSelf.dataModel.name;
                    api.account = weakSelf.dataModel.account;
                    api.account_bank = weakSelf.dataModel.account_bank;
                    [[LCNetWorkManager manager]requestApi:api success:^(id  _Nullable result1) {
                        if([result1 isKindOfClass:NSDictionary.class]){
                            [subscriber sendNext:result1];
                            [subscriber sendCompleted];
                            
                        }else{
                            [subscriber sendError:[NSError errorWithDomain:KLanguage(@"数据加载失败，请稍后再试" ) code:500 userInfo:nil]];
                        }
                                                } failure:^(NSError * _Nullable error1) {
                                                    [subscriber sendError:error1];
                                                }];
                }
               
                    
                return [RACDisposable disposableWithBlock:^{
                    
                }];
            }];
        }];
    }
    return _addAccountCommand;
}
- (RACSubject *)addAccountSubject{
    if (_addAccountSubject== nil) {
        _addAccountSubject = [RACSubject subject];
    }
    return _addAccountSubject;
}
@end
