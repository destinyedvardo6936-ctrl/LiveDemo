//
//  LCMineViewModel.m
//  LiveDemo
//
//  Created by mrgao on 2023/1/4.
//

#import "LCMineViewModel.h"
#import "LCUserInfoApi.h"
#import "LCBannerApi.h"
#import "LCGameConfigManager.h"
#import "LCMineUrlApi.h"
#import "LCKeFuUrlApi.h"
#import "LCApplyAgentApi.h"
#import "LCLocalDataTools.h"
#import "LCMessageListApi.h"
@implementation LCMineViewModel
- (void)lc_initialize {
    [self lc_bindLoadSignal];
   
    self.dataModel = [LCUserInfoManager shareManager].userInfo;
    @weakify(self)
    [[[self.bannerCommand.executionSignals switchToLatest] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.bannerSubject sendNext:x];
    }];
    
    [[self.bannerCommand.errors takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSError * _Nullable x) {
        @strongify(self)
        [self.bannerSubject sendNext:x];
    }];
    [[[self.urlCommand.executionSignals switchToLatest] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.urlSubject sendNext:x];
    }];
    
    [[self.urlCommand.errors takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSError * _Nullable x) {
        @strongify(self)
        [self.urlSubject sendNext:x];
    }];
    [[[self.applyAgentCommand.executionSignals switchToLatest] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.applyAgentSubject sendNext:x];
    }];
    
    [[self.applyAgentCommand.errors takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSError * _Nullable x) {
        @strongify(self)
        [self.applyAgentSubject sendNext:x];
    }];
    [[[self.messageCommand.executionSignals switchToLatest] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.messageSubject sendNext:x];
    }];
    
    [[self.messageCommand.errors takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSError * _Nullable x) {
        @strongify(self)
        [self.messageSubject sendNext:x];
    }];
}

- (LCBaseApi *)getLoadApi {
    LCUserInfoApi *api = [LCUserInfoApi new];
    api.userId = [LCUserInfoManager shareManager].userInfo.ID;
    api.userToken = [LCUserInfoManager shareManager].userInfo.token;
    return api;
}

- (id)dealWithLoadData:(id)result {
    if ([result isKindOfClass:NSDictionary.class]) {
        NSArray *a = result[@"info"];
        NSDictionary *dic = [a firstObject];
        [self.dataModel mj_setKeyValues:dic];
        [[LCUserInfoManager shareManager] updateUserInfo:self.dataModel];
        
    }

    return result;
}

- (void)dealWithLoadError:(NSError *)error {
}

#pragma mark---- 懒加载 -----
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
        
//        LCMineOptionModel *yxjl = [LCMineOptionModel new];
//        yxjl.leftImgName = @"icon_yxjlImg";
//        yxjl.title = KLanguage(@"游戏记录");
        LCMineOptionModel *czjl = [LCMineOptionModel new];
        czjl.leftImgName = @"icon_czjlImg";
        czjl.title = KLanguage(@"充值记录");
        LCMineOptionModel *tzjl = [LCMineOptionModel new];
        tzjl.leftImgName = @"icon_tzjlImg";
        tzjl.title = KLanguage(@"投注记录");
        LCMineOptionModel *zmmx = [LCMineOptionModel new];
        zmmx.leftImgName = @"icon_zmmxImg";
        zmmx.title = KLanguage(@"账目明细");
        
        LCMineOptionModel *dl = [LCMineOptionModel new];
        dl.leftImgName = @"icon_dlImg";
        dl.title = [LCUserInfoManager shareManager].userInfo.isdaili.intValue != 1 ? KLanguage(@"代理申请"):KLanguage(@"代理");
        
        LCMineOptionModel *sjrz = [LCMineOptionModel new];
        sjrz.leftImgName = @"icon_sjrzImg";
        sjrz.title = KLanguage(@"手机认证");
        LCMineOptionModel *wdbb = [LCMineOptionModel new];
        wdbb.leftImgName = @"icon_wdbbImg";
        wdbb.title = KLanguage(@"我的背包");
        LCMineOptionModel *dj = [LCMineOptionModel new];
        dj.leftImgName = @"icon_djImg";
        dj.title = KLanguage(@"等级");
        LCMineOptionModel *zskf = [LCMineOptionModel new];
        zskf.leftImgName = @"icon_zskfImg";
        zskf.title = KLanguage(@"专属客服");
        LCMineOptionModel *dlzx = [LCMineOptionModel new];
        dlzx.leftImgName = @"icon_dlzxImg";
        dlzx.title = KLanguage(@"家族中心");
        LCMineOptionModel *sz = [LCMineOptionModel new];
        sz.leftImgName = @"icon_settingBtn";
        sz.title = KLanguage(@"设置");
        
        
        [_dataArray addObject:[LCGameConfigManager shareManager].gameStatus ? @[czjl,tzjl,zmmx]:@[czjl,zmmx]];
        [_dataArray addObject:@[dl]];
        [_dataArray addObject:@[sjrz,wdbb,dj,zskf,dlzx,sz]];
        
    }

    return _dataArray;
}
- (NSMutableArray *)urlModelArr{
    if (_urlModelArr == nil) {
        _urlModelArr = [NSMutableArray array];
    }
    return _urlModelArr;
}
- (NSMutableArray *)bannerArray{
    if (_bannerArray == nil) {
        _bannerArray = [NSMutableArray array];
    }
    return _bannerArray;
}

- (RACCommand *)bannerCommand{
    if (_bannerCommand == nil){
        @weakify(self)
        _bannerCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                LCBannerApi *api = [LCBannerApi new];
                api.type = @"6";
                [[LCNetWorkManager manager] requestApi:api success:^(id  _Nullable result) {
                    if([result isKindOfClass:NSDictionary.class]){
                        NSArray *arr = result[@"info"];
                        [self.bannerArray removeAllObjects];
                        [self.bannerArray addObjectsFromArray:[LCBannerModel mj_objectArrayWithKeyValuesArray:arr]];
                        [subscriber sendNext:result];
                        [subscriber sendCompleted];
                    }else{
                        
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
    return _bannerCommand;
}
- (RACSubject *)bannerSubject{
    if (_bannerSubject == nil){
        _bannerSubject = [RACSubject subject];
    }
    return _bannerSubject;
}
- (RACCommand *)messageCommand{
    if (_messageCommand == nil){
        @weakify(self)
        _messageCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                LCMessageListApi *api = [LCMessageListApi new];
                [[LCNetWorkManager manager] requestApi:api success:^(id  _Nullable result) {
                    if([result isKindOfClass:NSDictionary.class]){
                        NSArray *arr = result[@"info"];
                        NSArray *temp =[LCMessageListModel mj_objectArrayWithKeyValuesArray:arr];
                        self.messageModel = [temp firstObject];
                        [subscriber sendNext:result];
                        [subscriber sendCompleted];
                    }else{
                        
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
    return _messageCommand;
}
- (RACSubject *)messageSubject{
    if (_messageSubject == nil){
        _messageSubject = [RACSubject subject];
    }
    return _messageSubject;
}
- (RACCommand *)urlCommand{
    if (_urlCommand == nil){
        @weakify(self)
        _urlCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                LCMineUrlApi *api = [LCMineUrlApi new];
                
                [[LCNetWorkManager manager] requestApi:api success:^(id  _Nullable result) {
                    if([result isKindOfClass:NSDictionary.class]){
                        NSArray *arr = result[@"info"];
                        [LCMineUrlModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                            return @{@"modelId":@"id"};
                        }];
                        [LCUrlListModel mj_setupObjectClassInArray:^NSDictionary *{
                            return @{@"list":@"LCMineUrlModel"};
                        }];
                        [self.urlModelArr removeAllObjects];
                        NSArray *temp= [LCUrlListModel mj_objectArrayWithKeyValuesArray:arr];
                        for (LCUrlListModel *m in temp) {
                            [self.urlModelArr addObjectsFromArray:m.list];
                        }
                        [LCLocalDataTools saveLoacalDataWithKey:@"commenUrl" object:temp catheType:LCLocalDataToolsSaveType_Library];
//                        [self.urlModelArr addObjectsFromArray:[LCUrlListModel mj_objectArrayWithKeyValuesArray:arr]];
                        [subscriber sendNext:result];
                        [subscriber sendCompleted];
                        
                    }else{
                        
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
    return _urlCommand;
}
- (RACSubject *)urlSubject{
    if (_urlSubject == nil){
        _urlSubject = [RACSubject subject];
    }
    return _urlSubject;
}
- (RACCommand *)applyAgentCommand{
    if (_applyAgentCommand == nil){
        @weakify(self)
        _applyAgentCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                LCApplyAgentApi *api = [LCApplyAgentApi new];
                
                [[LCNetWorkManager manager] requestApi:api success:^(id  _Nullable result) {
                    if([result isKindOfClass:NSDictionary.class]){
                        
                        [subscriber sendNext:result];
                        [subscriber sendCompleted];
                        
                    }else{
                        
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
    return _applyAgentCommand;
}
- (RACSubject *)applyAgentSubject{
    if (_applyAgentSubject == nil){
        _applyAgentSubject = [RACSubject subject];
    }
    return _applyAgentSubject;
}
//- (RACCommand *)kefuUrlCommand{
//    if (_kefuUrlCommand == nil){
//        @weakify(self)
//        _kefuUrlCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
//            @strongify(self)
//            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//                LCKeFuUrlApi *api = [LCKeFuUrlApi new];
//                
//                [[LCNetWorkManager manager] requestApi:api success:^(id  _Nullable result) {
//                    if([result isKindOfClass:NSDictionary.class]){
//                        NSArray *arr = result[@"info"];
//                        NSDictionary *dic = [arr firstObject];
//                        self.kefuUrl = dic[@"kefuurl"];
//                        
//                        [subscriber sendNext:result];
//                        [subscriber sendCompleted];
//                        
//                    }else{
//                        
//                        [subscriber sendError:[NSError errorWithDomain:KLanguage(@"数据加载失败，请稍后再试") code:500 userInfo:nil]];
//                    
//                }
//                   
//                } failure:^(NSError * _Nullable error) {
//                    [subscriber sendError:error];
//                }];
//                
//                return [RACDisposable disposableWithBlock:^{
//                    
//                }];
//            }];
//        }];
//    }
//    return _kefuUrlCommand;
//}
//- (RACSubject *)kefuUrlSubject{
//    if (_kefuUrlSubject == nil){
//        _kefuUrlSubject = [RACSubject subject];
//    }
//    return _kefuUrlSubject;
//}
@end
