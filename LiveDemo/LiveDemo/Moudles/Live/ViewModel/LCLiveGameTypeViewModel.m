//
//  LCLiveGameListViewModel.m
//  LiveDemo
//
//  Created by mrgao on 2023/3/16.
//

#import "LCLiveGameTypeViewModel.h"
#import "LCGameTypeApi.h"
#import "LCLiveBalanceApi.h"
@implementation LCLiveGameTypeViewModel
- (void)lc_initialize{
    [self lc_bindLoadSignal];
    @weakify(self)
   
    [[[self.balanceCommand.executionSignals switchToLatest] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.balanceSubject sendNext:x];
    }];
    
    [[self.balanceCommand.errors takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSError * _Nullable x) {
        @strongify(self)
        [self.balanceSubject sendNext:x];
    }];
    
}
- (LCBaseApi *)getLoadApi{
    return [LCGameTypeApi new];
}
- (id)dealWithLoadData:(id)result{
    if([result isKindOfClass:NSDictionary.class]){
        [LCGameTypeModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"modelId":@"id"};
        }];
        [self.dataArray removeAllObjects];
        [self.titleArray removeAllObjects];
        [self.dataArray addObjectsFromArray:[LCGameTypeModel mj_objectArrayWithKeyValuesArray:result[@"info"]]];
        for (LCGameTypeModel *model in self.dataArray) {
            [self.titleArray addObject:model.name];
        }

    }
    return result;
}
- (void)dealWithLoadError:(NSError *)error{
    
}
#pragma mark---- 懒加载 ----
- (NSMutableArray *)dataArray{
    if(!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)titleArray{
    if(!_titleArray){
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}

- (RACCommand *)balanceCommand{
    if (_balanceCommand == nil) {
        @weakify(self)
        _balanceCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id   _Nullable input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                LCLiveBalanceApi *api = [[LCLiveBalanceApi alloc] init];
               
                [[LCNetWorkManager manager] requestApi:api success:^(id  _Nullable result) {
                   
                    if ([result isKindOfClass:[NSDictionary class]]){
                        NSArray *a =result[@"info"];
                        NSDictionary *dic = [a firstObject];
                        self.balanceStr = [NSString stringWithFormat:@"%ld",[dic[@"coin"]integerValue]];
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
    return _balanceCommand;
}
- (RACSubject *)balanceSubject{
    if (_balanceSubject == nil) {
        _balanceSubject = [RACSubject subject];
    }
    return _balanceSubject;
}

@end
