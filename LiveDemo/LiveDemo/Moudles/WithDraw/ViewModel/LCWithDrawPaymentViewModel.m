//
//  LCWithDrawViewModel.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/21.
//

#import "LCWithDrawPaymentViewModel.h"
#import "LCNoticeModel.h"
#import "LCHomeNoticeApi.h"
#import "LCWithDrawPaymentApi.h"
@implementation LCWithDrawPaymentViewModel
- (void)lc_initialize{
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
}
- (LCBaseApi *)getLoadApi{
    LCWithDrawPaymentApi *api = [LCWithDrawPaymentApi new];
   
    return api;
}

- (id)dealWithLoadData:(id)result{
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSArray *a = result[@"info"];
//        NSDictionary *dic = [a firstObject];
        [self.dataArray removeAllObjects];
        NSArray *arr = [LCWithDrawPaymentModel mj_objectArrayWithKeyValuesArray:a];
        [self.dataArray addObjectsFromArray:arr];
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
- (NSMutableArray *)dataArray{
    if (_dataArray == nil){
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
                            if([dic[@"id"] intValue] == 3){
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
@end
