//
//  LCUpdatePersonalInfoViewModel.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/18.
//

#import "LCUpdatePersonalInfoViewModel.h"
#import "LCUpdatePersonalInfoApi.h"
@implementation LCUpdatePersonalInfoViewModel
- (void)lc_initialize{
    [self lc_bindLoadSignal];
    LCUserInfoModel *model = [LCUserInfoManager shareManager].userInfo;
    self.nickname = model.user_nicename;
    self.avaterStr = model.avatar;
    self.sex = model.sex;
    self.profile = model.signature;
    self.birthday = model.birthday;
    self.province = model.province;
    self.city = model.city;
    @weakify(self)
    [[[self.uploadCommand.executionSignals switchToLatest] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.uploadSubject sendNext:x];
    }];
    [[self.uploadCommand.errors takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSError * _Nullable x) {
        @strongify(self)
        [self.uploadSubject sendNext:x];
    }];
}
- (LCBaseApi *)getLoadApi{
    LCUpdatePersonalInfoApi *api = [LCUpdatePersonalInfoApi new];
    api.avaterStr = self.avaterStr;
    api.nickname = self.nickname;
    api.sex = self.sex;
    api.profile = self.profile;
    api.birthday = self.birthday;
    api.city = self.city;
    api.province = self.province;
    return api;
}
- (id)dealWithLoadData:(id)result{
    if([result isKindOfClass:NSDictionary.class]){
        LCUserInfoModel *model = [LCUserInfoManager shareManager].userInfo;
        model.user_nicename = self.nickname;
        model.avatar = self.avaterStr;
        model.signature = self.profile;
        model.sex = self.sex;
    }
    return result;
}
- (void)dealWithLoadError:(NSError *)error{
    
}
#pragma mark---- 懒加载 ----
- (RACCommand *)uploadCommand{
    if (_uploadCommand == nil) {
        @weakify(self)
        _uploadCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [[LCNetWorkManager manager]uploadImgs:self.avater success:^(id  _Nullable result) {
                    if ([result isKindOfClass:[NSDictionary class]]){
                        
                        self.avaterStr = [result objectForKey:@"info"];
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
    return _uploadCommand;
}
- (RACSubject *)uploadSubject{
    if (_uploadSubject == nil) {
        _uploadSubject = [RACSubject subject];
    }
    return _uploadSubject;
}
@end
