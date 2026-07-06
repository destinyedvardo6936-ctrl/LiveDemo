//
//  LCRechargeViewModel.m
//  LiveDemo
//
//  Created by mrgao on 2023/1/4.
//

#import "LCRechargeTypeViewModel.h"
#import "LCRechargeTypeApi.h"
#import "LCNoticeModel.h"
#import "LCHomeNoticeApi.h"
#import "LCMyWalletApi.h"
@implementation LCRechargeTypeViewModel
- (void)lc_initialize {
    self.currentIndex = 0;
    [self lc_bindLoadSignal];
    @weakify(self)
    [[[self.noticeCommand.executionSignals switchToLatest] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.noticeSubject sendNext:x];
    }];
    [[self.noticeCommand.errors takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSError * _Nullable x) {
        @strongify(self)
        [self.noticeSubject sendNext:x];
    }];
    [[[self.balanceCommand.executionSignals switchToLatest] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.balanceSubject sendNext:x];
    }];
    [[self.balanceCommand.errors takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSError * _Nullable x) {
        @strongify(self)
        [self.balanceSubject sendNext:x];
    }];
}

- (LCBaseApi *)getLoadApi {
    LCRechargeTypeApi *api = [LCRechargeTypeApi new];

    return api;
}

- (id)dealWithLoadData:(id)result {
    if ([result isKindOfClass:NSDictionary.class]) {
        NSDictionary *dic = result;
        NSDictionary *infoDic = dic[@"info"];
        NSArray *info = infoDic[@"list"];
        
        [self.dataArray removeAllObjects];
        [LCRechargeTypeModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"modelId":@"id"};
        }];
       
        [self.dataArray addObjectsFromArray:[LCRechargeTypeModel mj_objectArrayWithKeyValuesArray:info]];
        for (LCRechargeTypeModel *m in self.dataArray) {
            m.usdtretio = infoDic[@"usdtretio"];
            m.isSelected = [self.dataArray indexOfObject:m] == self.currentIndex;
        }
    }

    return result;
}

- (void)dealWithLoadError:(NSError *)error {
}

#pragma mark---- 懒加载 -----
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }

    return _dataArray;
}
- (NSMutableArray *)noticeArray{
    if (_noticeArray == nil){
        _noticeArray = [NSMutableArray array];
        
    }
    return _noticeArray;
}
- (RACCommand *)changeSelectIndexCommend{
    if (_changeSelectIndexCommend == nil) {
        @weakify(self)
        _changeSelectIndexCommend = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(LCRechargeTypeModel  *_Nullable input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                for (LCRechargeTypeModel *model in self.dataArray) {
                    model.isSelected = [model isEqual:input];
                    if(model.isSelected){
                        self.currentIndex = [self.dataArray indexOfObject:model];
                    }
                }
                [subscriber sendNext:input];
                [subscriber sendCompleted];
                return [RACDisposable disposableWithBlock:^{
                    
                }];
            }];
        }];
    }
    return _changeSelectIndexCommend;
}
- (RACCommand *)noticeCommand{
    if (_noticeCommand == nil){
        @weakify(self)
        _noticeCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                LCHomeNoticeApi *api = [LCHomeNoticeApi new];
                
                [[LCNetWorkManager manager] requestApi:api success:^(id  _Nullable result) {
                    if([result isKindOfClass:NSDictionary.class]){
                        NSArray *arr = result[@"info"];
                        for (NSDictionary *dic in arr) {
                            if([dic[@"id"] intValue] == 2){
                                [LCNoticeModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                                    return @{@"modelId":@"id"};
                                }];
                                [self.noticeArray removeAllObjects];
                                NSArray *temp = [LCNoticeModel mj_objectArrayWithKeyValuesArray:dic[@"list"]];
                                for (LCNoticeModel *model in temp) {
                                    [self.noticeArray addObject:model.content];
                                }
                                [self.noticeArray addObjectsFromArray:self.noticeArray];
//                                [self.noticeArray addObjectsFromArray:self.noticeArray];
                            }
                        }
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
    return _noticeCommand;
}
- (RACSubject *)noticeSubject{
    if (_noticeSubject == nil){
        _noticeSubject = [RACSubject subject];
    }
    return _noticeSubject;
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
@end
