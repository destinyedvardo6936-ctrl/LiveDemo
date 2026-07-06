//
//  LCLoginViewModel.m
//  LiveDemo
//
//  Created by mrgao on 2023/1/17.
//

#import "LCLoginViewModel.h"
#import "LCLoginApi.h"
#import "LCCodeApi.h"
@implementation LCLoginViewModel
- (void)lc_initialize{
    [self lc_bindLoadSignal];
    self.country_code = @"86";
    @weakify(self)
   
    [[[self.codeCommand.executionSignals switchToLatest] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.codeSubject sendNext:x];
    }];
    [[self.codeCommand.errors takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSError * _Nullable x) {
        @strongify(self)
        [self.codeSubject sendNext:x];
    }];
}
- (LCBaseApi *)getLoadApi{
    LCLoginApi *api = [LCLoginApi new];
    api.phone = self.phone;
    api.code = self.code;
    api.country_code = self.country_code;
    return api;
}
- (id)dealWithLoadData:(id)result{
    if([result isKindOfClass:NSDictionary.class]){
        NSArray *arr = result[@"info"];
        NSDictionary *dic = [arr firstObject];
        LCUserInfoModel *mdeol = [LCUserInfoModel mj_objectWithKeyValues:dic];
        [[LCUserInfoManager shareManager] updateUserInfo:mdeol];
        [[NSNotificationCenter defaultCenter] postNotificationName:LCLoginNot object:nil];
    }
    return result;
}
- (void)dealWithLoadError:(NSError *)error{
    
}
#pragma mark---- 懒加载 ----
- (RACCommand *)codeCommand{
    if (_codeCommand == nil){
        @weakify(self)
        _codeCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                LCCodeApi *api = [LCCodeApi new];
                api.phone = self.phone;
                api.country_code = self.country_code;
                [[LCNetWorkManager manager] requestApi:api success:^(id  _Nullable result) {
                    if ([result isKindOfClass:[NSDictionary class]]) {
                        
                        [subscriber sendNext:result];
                        [subscriber sendCompleted];
                        
                    }else{
                        
                        [subscriber sendError:[NSError errorWithDomain:@"数据加载失败，请稍后再试" code:500 userInfo:nil]];
                    }
                  
                } failure:^(NSError * _Nullable error) {
                    [subscriber sendError:error];
                }];
   
                return [RACDisposable disposableWithBlock:^{
                    
                }];
            }];
        }];
    }
    return _codeCommand;
}
- (RACSubject *)codeSubject{
    if (_codeSubject == nil){
        _codeSubject = [RACSubject subject];
    }
    return _codeSubject;
}
@end
