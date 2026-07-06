//
//  LCRechargeViewModel.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/15.
//

#import "LCRechargeViewModel.h"
#import "LCRechargeAmountApi.h"
#import "LCBankOrVirtualSubmitApi.h"
#import "LCOtherRechargeApi.h"

@implementation LCRechargeViewModel
- (void)lc_initialize{
    [self lc_bindLoadSignal];
    @weakify(self)
    [[[self.bankOrVirtualSubmitCommand.executionSignals switchToLatest] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.bankOrVirtualSubmitSubject sendNext:x];
    }];
    [[self.bankOrVirtualSubmitCommand.errors takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSError * _Nullable x) {
        @strongify(self)
        [self.bankOrVirtualSubmitSubject sendNext:x];
    }];
    [[[self.otherSubmitCommand.executionSignals switchToLatest] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.otherSubmitSubject sendNext:x];
    }];
    [[self.otherSubmitCommand.errors takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSError * _Nullable x) {
        @strongify(self)
        [self.otherSubmitSubject sendNext:x];
    }];
    
}
- (LCBaseApi *)getLoadApi{
    LCRechargeAmountApi *api = [LCRechargeAmountApi new];
    api.qudaoid = self.dataModel.modelId;
    return api;
}
- (id)dealWithLoadData:(id)result{
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = result[@"info"] ;
        if([self.dataModel.modelId intValue] <= 3){
           
                [LCRechargeConnetPersonModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                    return @{@"modelId":@"id"};
                }];
            
            
            [self.personArray removeAllObjects];
            if([self.dataModel.modelId intValue] == 1){
                [self.personArray addObjectsFromArray:[LCRechargeConnetPersonModel mj_objectArrayWithKeyValuesArray:dic[@"datalist"]]];
            }else{
                [self.personArray addObject:[LCRechargeConnetPersonModel mj_objectWithKeyValues:dic[@"list"] ]];
                self.selectPersonModel = [self.personArray firstObject];
            }
           
            [LCRechargeMoneyModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"modelId":@"id"};
            }];
            [self.moneyArray removeAllObjects];
            [self.moneyArray addObjectsFromArray:[LCRechargeMoneyModel mj_objectArrayWithKeyValuesArray:dic[@"moneylist"]]];
            if(!([self.dataModel.modelId intValue] == 2 || [self.dataModel.modelId intValue] == 3)){
                self.selectMoneyModel = [self.moneyArray firstObject];
            }
            
        }else{
            [LCRechargeSubTypeModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"modelId":@"id"};
            }];
            [LCRechargeMoneyModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"modelId":@"id"};
            }];
            [LCRechargeSubTypeModel mj_setupObjectClassInArray:^NSDictionary *{
                return @{@"moneylist":@"LCRechargeMoneyModel"};
            }];
            [self.subPayWayArray addObjectsFromArray:[LCRechargeSubTypeModel mj_objectArrayWithKeyValuesArray:dic[@"list"]]];
            self.selectSubTypeModel = [self.subPayWayArray firstObject];
            
        }
        

        
    }
  
    
    return result;
}

- (void)dealWithLoadError:(NSError *)error{
    
}
#pragma mark---- 懒加载 ----
- (NSMutableArray *)moneyArray{
    if (_moneyArray == nil) {
        _moneyArray = [NSMutableArray array];
        
    }
    return _moneyArray;
}
- (NSMutableArray *)personArray{
    if (_personArray == nil) {
        _personArray = [NSMutableArray array];
        
    }
    return _personArray;
}
- (NSMutableArray *)subPayWayArray{
    if (_subPayWayArray == nil) {
        _subPayWayArray = [NSMutableArray array];
        
    }
    return _subPayWayArray;
}

- (RACCommand *)bankOrVirtualSubmitCommand{
    if (_bankOrVirtualSubmitCommand == nil){
        @weakify(self)
        _bankOrVirtualSubmitCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                LCBankOrVirtualSubmitApi *api = [LCBankOrVirtualSubmitApi new];
                api.qudaoid = self.dataModel.modelId;
                api.moneylistid = self.selectMoneyModel.modelId;
                api.money = self.selectMoneyModel.money;
//                if(self.dataModel.modelId.intValue == 2){
                    api.name = self.selectPersonModel.name;
//                }
               
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
    return _bankOrVirtualSubmitCommand;
}
- (RACSubject *)bankOrVirtualSubmitSubject{
    if (_bankOrVirtualSubmitSubject == nil){
        _bankOrVirtualSubmitSubject = [RACSubject subject];
    }
    return _bankOrVirtualSubmitSubject;
}
- (RACCommand *)otherSubmitCommand{
    if (_otherSubmitCommand == nil){
        @weakify(self)
        _otherSubmitCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                LCOtherRechargeApi *api = [LCOtherRechargeApi new];
                api.qudaoid = self.dataModel.modelId;
                api.moneylistid = self.selectMoneyModel.modelId;
                api.money = self.selectMoneyModel.money;
                api.paytypeid = self.selectSubTypeModel.paycode;
                
                [[LCNetWorkManager manager] requestApi:api success:^(id  _Nullable result) {
                    if ([result isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *dic = result ;
                       
                       
                        
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
    return _otherSubmitCommand;
}
- (RACSubject *)otherSubmitSubject{
    if (_otherSubmitSubject == nil){
        _otherSubmitSubject = [RACSubject subject];
    }
    return _otherSubmitSubject;
}

@end
