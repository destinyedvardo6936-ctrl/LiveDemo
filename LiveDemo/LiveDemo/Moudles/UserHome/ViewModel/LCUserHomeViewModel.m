//
//  LCUserHomeViewModel.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/22.
//

#import "LCUserHomeViewModel.h"
#import "LCUserHomeApi.h"
#import "LCFollowApi.h"
@implementation LCUserHomeViewModel
- (void)lc_initialize{
    [self lc_bindLoadSignal];
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
    LCUserHomeApi *api = [LCUserHomeApi new];
    api.userId = self.userId;
    return api;
}
- (id)dealWithLoadData:(id)result{
    if([result isKindOfClass:NSDictionary.class]){
        NSArray *a = result[@"info"];
        NSDictionary *dic = [a firstObject];
        [LCUserHomeModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"modelId":@"id"};
        }];
        [LCUserHomeModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"contribute":@"LCUserContributeModel"};
        }];
        [self.dataModel mj_setKeyValues:dic];
    }
    return result;
}
- (void)dealWithLoadError:(NSError *)error{
    
}
#pragma mark---- 懒加载 ----
- (LCUserHomeModel *)dataModel{
    if(_dataModel == nil){
        _dataModel = [LCUserHomeModel new];
    }
    return _dataModel;
}
- (RACCommand *)followCommand{
    if (_followCommand == nil) {
//        @weakify(self)
        _followCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(LCUserHomeModel *  _Nullable input) {
//            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                LCFollowApi *api = [[LCFollowApi alloc] init];
                api.userId = input.modelId;
//                api.postId = input.postId;
                [[LCNetWorkManager manager] requestApi:api success:^(id  _Nullable result) {
                   
                    if ([result isKindOfClass:[NSDictionary class]]){
                        
                        input.isattention = input.isattention.boolValue?@"0":@"1";

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
