//
//  LCSettingViewModel.m
//  LiveDemo
//
//  Created by mrgao on 2023/1/7.
//

#import "LCSettingViewModel.h"
#import "LCLanguageManager.h"
#import "LCCheckVersionApi.h"
#import "LCLogoutApi.h"
@implementation LCSettingViewModel
- (void)lc_initialize {
    [self lc_bindLoadSignal];
    @weakify(self)
   
    [[[self.logoutCommand.executionSignals switchToLatest] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.logoutSubject sendNext:x];
    }];
    [[self.logoutCommand.errors takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSError * _Nullable x) {
        @strongify(self)
        [self.logoutSubject sendNext:x];
    }];
    [self reloadData];
   
   
}
- (void)reloadData{
    LCSettingModel *zhaqzx = [LCSettingModel new];
    zhaqzx.leftTitle = KLanguage(@"账号安全中心");
    zhaqzx.rightValue = KLanguage(@"手机认证");
    zhaqzx.needAccess = YES;
    zhaqzx.type = 0;
    LCSettingModel *yy = [LCSettingModel new];
    yy.leftTitle = KLanguage(@"语言");
    yy.rightValue = [[LCLanguageManager shareManager] getLanguageDescirbe];
    yy.needAccess = YES;
    yy.type = 0;
    
    LCSettingModel *yszc = [LCSettingModel new];
    yszc.leftTitle = KLanguage(@"隐私政策");
//    yszc.rightValue = [[LCLanguageManager shareManager] getLanguageDescirbe];
    yszc.needAccess = YES;
    yszc.type = 0;
//    LCSettingModel *zfmm = [LCSettingModel new];
//    zfmm.leftTitle = KLanguage(@"支付密码");
//    zfmm.needAccess = YES;
//    zfmm.type = 0;
    
    LCSettingModel *jcgx = [LCSettingModel new];
    jcgx.leftTitle = KLanguage(@"检查更新");
    jcgx.needAccess = YES;
    jcgx.type = 2;
    
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:@[zhaqzx,yy,yszc,/*zfmm,*/jcgx]];
}
- (LCBaseApi *)getLoadApi {
    LCCheckVersionApi *api = [LCCheckVersionApi new];
    
    return api;
}

- (id)dealWithLoadData:(id)result {
    if ([result isKindOfClass:NSDictionary.class]) {
        NSDictionary *dic = result[@"info"];
        
        [self.versionModel mj_setKeyValues:dic];
        LCSettingModel *jcgx = [self.dataArray lastObject];
        jcgx.rightValue = [self.versionModel.version isEqualToString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]? KLanguage(@"最新"):KLanguage(@"更新");
    }

    return result;
}

- (void)dealWithLoadError:(NSError *)error {
}
#pragma mark---- 懒加载 -----
- (LCVersionModel *)versionModel{
    if(!_versionModel){
        _versionModel = [LCVersionModel new];
    }
    return _versionModel;
}
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
       
       
        
    }

    return _dataArray;
}
- (RACCommand *)changeLanguageCommand{
    if(!_changeLanguageCommand){
        @weakify(self)
        _changeLanguageCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(NSString  *_Nullable input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [[LCLanguageManager shareManager] changeToLanguageDescribe:input];
                [self.loadDataCommend execute:@(YES)];
                [self reloadData];
                [subscriber sendNext:input];
                [subscriber sendCompleted];
                return [RACDisposable disposableWithBlock:^{
                    
                }];
            }];
        }];
    }
    return _changeLanguageCommand;
}

- (RACCommand *)logoutCommand{
    if (_logoutCommand == nil){
        @weakify(self)
        _logoutCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                LCLogoutApi *api = [LCLogoutApi new];
                [[LCNetWorkManager manager] requestApi:api success:^(id  _Nullable result) {
                    if ([result isKindOfClass:[NSDictionary class]]) {
                        
                        [[LCUserInfoManager shareManager] clearUserInfo];
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
    return _logoutCommand;
}
- (RACSubject *)logoutSubject{
    if (_logoutSubject == nil){
        _logoutSubject = [RACSubject subject];
    }
    return _logoutSubject;
}
@end
