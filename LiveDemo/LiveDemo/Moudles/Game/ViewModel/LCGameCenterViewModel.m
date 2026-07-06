//
//  LCGameCenterViewModel.m
//  LiveDemo
//
//  Created by mrgao on 2023/3/17.
//

#import "LCGameCenterViewModel.h"
#import "LCGameTypeApi.h"
#import "LCGameListApi.h"
#import "LCBannerApi.h"
#import "LCHomeNoticeApi.h"
#import "LCLiveBalanceApi.h"
#import "LCThirdGameApi.h"
#import "LCGameThirdTypeApi.h"
#import "LCGameThirdListApi.h"
#import "LCGameEdhsApi.h"
#import "LCHuiShouApi.h"
@implementation LCGameCenterViewModel
- (void)lc_initialize{
    [self lc_bindLoadSignal];
    @weakify(self)
    [[[self.bannerCommand.executionSignals switchToLatest] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.bannerSubject sendNext:x];
    }];
    
    [[self.bannerCommand.errors takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSError * _Nullable x) {
        @strongify(self)
        [self.bannerSubject sendNext:x];
    }];
    [[[self.thirdGameTypeCommand.executionSignals switchToLatest] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.thirdGameTypeSubject sendNext:x];
    }];
    
    [[self.thirdGameTypeCommand.errors takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSError * _Nullable x) {
        @strongify(self)
        [self.thirdGameTypeSubject sendNext:x];
    }];
    [[[self.gameListCommand.executionSignals switchToLatest] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.gameListSubject sendNext:x];
    }];
    
    [[self.gameListCommand.errors takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSError * _Nullable x) {
        @strongify(self)
        [self.gameListSubject sendNext:x];
    }];
    [[[self.balanceCommand.executionSignals switchToLatest] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.balanceSubject sendNext:x];
    }];
    
    [[self.balanceCommand.errors takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSError * _Nullable x) {
        @strongify(self)
        [self.balanceSubject sendNext:x];
    }];
    [[[self.noticeCommand.executionSignals switchToLatest] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.noticeSubject sendNext:x];
    }];
    
    [[self.noticeCommand.errors takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSError * _Nullable x) {
        @strongify(self)
        [self.noticeSubject sendNext:x];
    }];
    
    [[[self.enterThirdGameCommand.executionSignals switchToLatest] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.enterThirdGameSubject sendNext:x];
    }];
    
    [[self.enterThirdGameCommand.errors takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSError * _Nullable x) {
        @strongify(self)
        [self.enterThirdGameSubject sendNext:x];
    }];
    [[[self.huishouCommand.executionSignals switchToLatest] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.huishouSubject sendNext:x];
    }];
    
    [[self.huishouCommand.errors takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSError * _Nullable x) {
        @strongify(self)
        [self.huishouSubject sendNext:x];
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
        
        [self.dataArray addObjectsFromArray:[LCGameTypeModel mj_objectArrayWithKeyValuesArray:result[@"info"]]];
        BOOL hasSelected = NO;
        for (LCGameTypeModel *model in self.dataArray) {
            if(model.isSelected){
                hasSelected = YES;
            }
        }
        if(!hasSelected){
            self.selectTypeModel = [self.dataArray firstObject];
            self.selectTypeModel.isSelected = YES;
            [self.gameListCommand execute:@(YES)];
            
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
- (NSMutableArray *)bannerArray{
    if (_bannerArray == nil) {
        _bannerArray = [NSMutableArray array];
    }
    return _bannerArray;
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

- (RACCommand *)bannerCommand{
    if (_bannerCommand == nil){
        @weakify(self)
        _bannerCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                LCBannerApi *api = [LCBannerApi new];
                api.type = @"7";
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
- (RACCommand *)balanceCommand{
    if (_balanceCommand == nil) {
        @weakify(self)
        _balanceCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id   _Nullable input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                LCGameEdhsApi *api = [[LCGameEdhsApi alloc]init];
                [[LCNetWorkManager manager] requestApi:api success:^(id  _Nullable result) {
                   
                    if ([result isKindOfClass:[NSDictionary class]]){
                        NSArray *a =result[@"info"];
                        LCLiveBalanceApi *balanceApi = [[LCLiveBalanceApi alloc] init];
                       
                        [[LCNetWorkManager manager] requestApi:balanceApi success:^(id  _Nullable result) {
                           
                            if ([result isKindOfClass:[NSDictionary class]]){
                                NSArray *a =result[@"info"];
                                NSDictionary *dic = [a firstObject];
                                self.balanceStr = [NSString stringWithFormat:@"%ld",[dic[@"coin"]integerValue]];
                                LCUserInfoModel *model = [LCUserInfoManager shareManager].userInfo;
                                model.coin = self.balanceStr;
                                [[LCUserInfoManager shareManager] updateUserInfo:model];
                                [subscriber sendNext:result];
                                [subscriber sendCompleted];
                            } else{
                                [subscriber sendError:[NSError errorWithDomain:KLanguage(@"数据加载失败，请稍后再试") code:500 userInfo:nil]];
                            }
                        } failure:^(NSError * _Nullable error) {
                            [subscriber sendError:error];
                        }];
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
- (RACCommand *)thirdGameTypeCommand{
    if (_thirdGameTypeCommand == nil) {
        @weakify(self)
        _thirdGameTypeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id   _Nullable input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                   
                        LCGameThirdTypeApi *api = [[LCGameThirdTypeApi alloc]init];
                        api.typeId = self.selectTypeModel.modelId;
                        [[LCNetWorkManager manager] requestApi:api success:^(id  _Nullable result) {
                           
                            if ([result isKindOfClass:[NSDictionary class]]){
                                NSArray *a =result[@"info"];
                                [LCGameSubTypeModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                                    return @{@"modelId":@"id"};
                                }];
                                NSMutableArray *temp = [LCGameSubTypeModel mj_objectArrayWithKeyValuesArray:a];
                                self.selectTypeModel.typeArray = temp;
                                
                                self.selectTypeModel.selectTypeModel = [temp firstObject];
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
    return _thirdGameTypeCommand;
}
- (RACSubject *)thirdGameTypeSubject{
    if (_thirdGameTypeSubject == nil) {
        _thirdGameTypeSubject = [RACSubject subject];
    }
    return _thirdGameTypeSubject;
}
- (RACCommand *)gameListCommand{
    if (_gameListCommand == nil) {
        @weakify(self)
        _gameListCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id   _Nullable input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
    
                    if([self.selectTypeModel.modelId isEqualToString:@"0"]){
                        LCGameListApi *api = [[LCGameListApi alloc]init];
                        api.typeId = self.selectTypeModel.modelId;
        //                LCLiveBalanceApi *api = [[LCLiveBalanceApi alloc] init];
                       
                        [[LCNetWorkManager manager] requestApi:api success:^(id  _Nullable result) {
                           
                            if ([result isKindOfClass:[NSDictionary class]]){
                                NSArray *a =result[@"info"];
                                [LCGameListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                                    return @{@"modelId":@"id"};
                                }];
                                NSMutableArray *temp = [LCGameListModel mj_objectArrayWithKeyValuesArray:a];
                                self.selectTypeModel.dataArray = temp;

                                [subscriber sendNext:result];
                                [subscriber sendCompleted];
                            } else{
                                [subscriber sendError:[NSError errorWithDomain:KLanguage(@"数据加载失败，请稍后再试") code:500 userInfo:nil]];
                            }
                        } failure:^(NSError * _Nullable error) {
                            [subscriber sendError:error];
                        }];
                    }else{
                        if(self.selectTypeModel.selectTypeModel){
                            LCGameThirdListApi *api = [[LCGameThirdListApi alloc]init];
                            api.pid = self.selectTypeModel.selectTypeModel.topclass_id;
                            api.oneClassId = self.selectTypeModel.selectTypeModel.modelId;
       
                            [[LCNetWorkManager manager] requestApi:api success:^(id  _Nullable result) {
                               
                                if ([result isKindOfClass:[NSDictionary class]]){
                                    NSArray *a =result[@"info"];
                                    [LCGameListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                                        return @{@"modelId":@"id"};
                                    }];
                                    NSMutableArray *temp = [LCGameListModel mj_objectArrayWithKeyValuesArray:a];
                                    self.selectTypeModel.dataArray = temp;
            
                                    [subscriber sendNext:result];
                                    [subscriber sendCompleted];
                                } else{
                                    [subscriber sendError:[NSError errorWithDomain:KLanguage(@"数据加载失败，请稍后再试") code:500 userInfo:nil]];
                                }
                            } failure:^(NSError * _Nullable error) {
                                [subscriber sendError:error];
                            }];
  
                       
                        }else{
                            [self.selectTypeModel.dataArray removeAllObjects];
                            [subscriber sendNext:@(YES)];
                            [subscriber sendCompleted];                }
                        
                                        
                                   
                        
                        
        
                       
                        
                    }
                
                
                
                    
                return [RACDisposable disposableWithBlock:^{
                    
                }];
            }];
        }];
    }
    return _gameListCommand;
}
- (RACSubject *)gameListSubject{
    if (_gameListSubject == nil) {
        _gameListSubject = [RACSubject subject];
    }
    return _gameListSubject;
}
- (RACCommand *)enterThirdGameCommand{
    if (_enterThirdGameCommand == nil) {
        @weakify(self)
        _enterThirdGameCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(LCGameListModel *   _Nullable input) {
//            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                LCThirdGameApi *api = [[LCThirdGameApi alloc]init];
                api.biaoshi = input.biaoshi;
                api.type = input.type;
                api.code = input.code;
//                LCLiveBalanceApi *api = [[LCLiveBalanceApi alloc] init];
               
                [[LCNetWorkManager manager] requestApi:api success:^(id  _Nullable result) {
                   
                    if ([result isKindOfClass:[NSDictionary class]]){
                        NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithDictionary:result];
                        NSMutableDictionary *infoDic = [NSMutableDictionary dictionaryWithDictionary:temp[@"info"]];
                        infoDic[@"biaoshi"] = input.biaoshi;
                        temp[@"info"] = infoDic.copy;
                        [subscriber sendNext:temp];
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
    return _enterThirdGameCommand;
}
- (RACSubject *)enterThirdGameSubject{
    if (_enterThirdGameSubject == nil) {
        _enterThirdGameSubject = [RACSubject subject];
    }
    return _enterThirdGameSubject;
}
- (RACCommand *)huishouCommand{
    if (_huishouCommand == nil) {
        @weakify(self)
        _huishouCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(LCGameListModel *   _Nullable input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                LCHuiShouApi *api = [[LCHuiShouApi alloc]init];
               
//                LCLiveBalanceApi *api = [[LCLiveBalanceApi alloc] init];
               
                [[LCNetWorkManager manager] requestApi:api success:^(id  _Nullable result) {
                   
                    if ([result isKindOfClass:[NSDictionary class]]){
                        LCLiveBalanceApi *balanceApi = [[LCLiveBalanceApi alloc] init];
                       
                        [[LCNetWorkManager manager] requestApi:balanceApi success:^(id  _Nullable result) {
                           
                            if ([result isKindOfClass:[NSDictionary class]]){
                                NSArray *a =result[@"info"];
                                NSDictionary *dic = [a firstObject];
                                self.balanceStr = [NSString stringWithFormat:@"%ld",[dic[@"coin"]integerValue]];
                                LCUserInfoModel *model = [LCUserInfoManager shareManager].userInfo;
                                model.coin = self.balanceStr;
                                [[LCUserInfoManager shareManager] updateUserInfo:model];
                                
                            }
                        } failure:^(NSError * _Nullable error) {
                            
                        }];
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
    return _huishouCommand;
}
- (RACSubject *)huishouSubject{
    if (_huishouSubject == nil) {
        _huishouSubject = [RACSubject subject];
    }
    return _huishouSubject;
}
@end
