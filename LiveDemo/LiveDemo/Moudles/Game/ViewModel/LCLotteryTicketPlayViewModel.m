//
//  LCLotteryTicketPlayViewModel.m
//  LiveDemo
//
//  Created by mrgao on 2023/3/18.
//

#import "LCLotteryTicketPlayViewModel.h"
#import "LCLotteryTicketPlayApi.h"
#import "LCLiveBalanceApi.h"
#import "LCLotteryTicketResultApi.h"
#import "LCLotteryTicketSocketInfoApi.h"
#import "LCSocketManager.h"

@interface LCLotteryTicketPlayViewModel ()<LCSocketManagerDelegate>

@end
@implementation LCLotteryTicketPlayViewModel
- (void)lc_initialize{
    [self lc_bindLoadSignal];
    @weakify(self)
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:LCGameLotteryTicketSelectNot object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        LCLotteryTicketWanFaModel *wanfaModel = x.object;
        if(self.coinModel){
            wanfaModel.coin = self.coinModel.coin;
        }
        if(self.customZhuMoneyStr){
            wanfaModel.coin = self.customZhuMoneyStr;
        }
        if(wanfaModel.isSelected){
            if(![self.wanfaSelectArr containsObject:wanfaModel]){
                [self.wanfaSelectArr addObject:wanfaModel];
            }
        }else{
            if([self.wanfaSelectArr containsObject:wanfaModel]){
                [self.wanfaSelectArr removeObject:wanfaModel];
            }
        }
        self.xiazhuCount = self.wanfaSelectArr.count;
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:LCGameLotteryTicketWanfaDeleteNot object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        LCLotteryTicketWanFaModel *wanfaModel = x.object;
        wanfaModel.coin = nil;
        if([self.wanfaSelectArr containsObject:wanfaModel]){
            [self.wanfaSelectArr removeObject:wanfaModel];
        }
       
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:LCLiveLotteryTicketTimeCutDownNot object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        if([x.object isKindOfClass:NSDictionary.class]){
            NSDictionary *dic = x.object;
            if([dic[@"caipiao"] isEqualToString:self.originModel.biaoshi]){
                NSDictionary *timeDic = dic;
                self.cutDownTimeStr =[NSString stringWithFormat:@"%ld", [timeDic[@"daojishi"] integerValue]];
                if([timeDic[@"daojishi"] integerValue] == 1){
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if(!self.isResultRequestSending){
                            [self.kaijiangResultCommand execute:@(YES)];
                        }
                    });
                    
                    
                }
                NSString *nowQihao = timeDic[@"benqihao"];
                if(![nowQihao isEqualToString:self.nowQihaoStr]){
                    self.nowQihaoStr = nowQihao;
                }
              
            }
        }
        
    }];
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:LCLiveLotteryTicketKaijiangSocketResultNot object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        NSDictionary *dic = x.object;
        LCLotteryTicketSQKJModel *model = [LCLotteryTicketSQKJModel mj_objectWithKeyValues:dic];
        if(![model.expect isEqualToString:self.sqkj.expect] && [model.name isEqualToString:self.originModel.biaoshi]){
            self.sqkj = [LCLotteryTicketSQKJModel mj_objectWithKeyValues:dic];


        }


    }];
    [[[self.kaijiangResultCommand.executionSignals switchToLatest] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.kaijiangResultSubject sendNext:x];
    }];
    
    [[self.kaijiangResultCommand.errors takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSError * _Nullable x) {
        @strongify(self)
        [self.kaijiangResultSubject sendNext:x];
    }];
    [[[self.socketInfoCommand.executionSignals switchToLatest] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.socketInfoSubject sendNext:x];
    }];
    
    [[self.socketInfoCommand.errors takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSError * _Nullable x) {
        @strongify(self)
        [self.socketInfoSubject sendNext:x];
    }];
  
}
- (LCBaseApi *)getLoadApi{
    LCLotteryTicketPlayApi *api = [LCLotteryTicketPlayApi new];
    api.gameId = self.originModel.modelId;
    api.biaoshi = self.originModel.biaoshi;
    return api;
}
- (id)dealWithLoadData:(id)result{
    if([result isKindOfClass:NSDictionary.class]){
        self.dataModel = [LCLotteryTicketPlayModel mj_objectWithKeyValues:result[@"info"]];
        [self.wanfaSegArr removeAllObjects];
        
        for (NSArray *a in self.dataModel.wanfa) {
            LCLotteryTicketWanFaModel *m = [a firstObject];
            if(![self.wanfaSegArr containsObject:m.wanfaname]){
                [self.wanfaSegArr addObject:m.wanfaname];
            }
            
            for (LCLotteryTicketWanFaModel *mo in a) {
                mo.gameid = self.originModel.modelId;
                mo.biaoshi = self.originModel.biaoshi;
                mo.gameName = self.originModel.name;
               
                
            }
        }
        self.sqkj = [self.dataModel.sqkj firstObject];
    }
    return result;
}
- (void)dealWithLoadError:(NSError *)error{
    
}
- (NSMutableArray *)getWanfaArrWithTitle:(NSString *)title{
    NSMutableArray *temp  = [NSMutableArray array];
    for (NSArray *a in self.dataModel.wanfa) {
        LCLotteryTicketWanFaModel *m = [a firstObject];
        if([title isEqualToString:m.wanfaname]){
            [temp addObjectsFromArray:a];
        }
    }

    return temp;
}
#pragma mark---- LCSocketManagerDelegate ----
- (void)connectFailured:(NSError *)error{}
- (void)connectSuccess:(id)result{
    LCUserInfoModel *model = [LCUserInfoManager shareManager].userInfo;
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_":@"gameinfo",
                                        @"caipiao":self.originModel.biaoshi,
                                        @"token": model.token
                                        }
                                    ],
                            @"retcode":@"000000",
                            @"retmsg":@"OK"
                            }
                        ];
    [[LCSocketManager shareManager] sendMessage:msgData eventName:@"game"];
}
- (void)disConnect:(id)result{}
- (void)netWorkChanged{}
//- (void)sendMessageSuccess:(id)result;
//- (void)sendMessageFailured:(NSError *)error;
- (void)receiveMessage:(id)message{
    
}
#pragma mark---- 懒加载 ----

- (NSMutableArray *)wanfaSegArr{
    if(!_wanfaSegArr){
        _wanfaSegArr = [NSMutableArray array];
    }
    return _wanfaSegArr;
}
- (NSMutableArray *)wanfaSelectArr{
    if(!_wanfaSelectArr){
        _wanfaSelectArr = [NSMutableArray array];
    }
    return _wanfaSelectArr;
}
- (RACCommand *)changeWanfaSegCommand{
    if (_changeWanfaSegCommand == nil) {
        @weakify(self)
        _changeWanfaSegCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSNumber  * _Nullable input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                self.wanfaSelectTitle = self.wanfaSegArr[[input integerValue]];
                for (LCLotteryTicketWanFaModel *m in self.wanfaSelectArr) {
                    m.isSelected = NO;
                }
                [self.wanfaSelectArr removeAllObjects];
                self.xiazhuCount = self.wanfaSelectArr.count;
                [subscriber sendNext:input];
                [subscriber sendCompleted];
                
                    
                return [RACDisposable disposableWithBlock:^{
                    
                }];
            }];
        }];
    }
    return _changeWanfaSegCommand;
}
- (RACCommand *)clearSelectCommand{
    if (_clearSelectCommand == nil) {
        @weakify(self)
        _clearSelectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id   _Nullable input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                for (LCLotteryTicketWanFaModel *m in self.wanfaSelectArr) {
                    m.isSelected = NO;
                    m.coin = nil;
                    
                }
                
                [self.wanfaSelectArr removeAllObjects];
                self.xiazhuCount = self.wanfaSelectArr.count;
                [subscriber sendNext:input];
                [subscriber sendCompleted];
                
                    
                return [RACDisposable disposableWithBlock:^{
                    
                }];
            }];
        }];
    }
    return _clearSelectCommand;
}
- (RACCommand *)jixuanCommand{
    if (_jixuanCommand == nil) {
        @weakify(self)
        _jixuanCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id   _Nullable input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                for (LCLotteryTicketWanFaModel *m in self.wanfaSelectArr) {
                    m.isSelected = NO;
                }
                [self.wanfaSelectArr removeAllObjects];
                NSArray *temp = [self getWanfaArrWithTitle:self.wanfaSelectTitle];
                NSInteger selectIndex = arc4random() % (temp.count);
                LCLotteryTicketWanFaModel *model = temp[selectIndex];
                model.isSelected = YES;
                if(self.coinModel){
                    model.coin = self.coinModel.coin;
                }
                if(self.customZhuMoneyStr){
                    model.coin = self.customZhuMoneyStr;
                }
                [self.wanfaSelectArr addObject:model];
                self.xiazhuCount = self.wanfaSelectArr.count;
                [subscriber sendNext:input];
                [subscriber sendCompleted];
                
                    
                return [RACDisposable disposableWithBlock:^{
                    
                }];
            }];
        }];
    }
    return _jixuanCommand;
}
- (RACCommand *)selectCoinCommand{
    if (_selectCoinCommand == nil) {
        @weakify(self)
        _selectCoinCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(LCLotteryTicketCoinModel *   _Nullable input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                self.customZhuMoneyStr = nil;
                for (LCLotteryTicketCoinModel *m in self.dataModel.coinimg) {
                    if([m isEqual:input]){
                        m.isSelected = YES;
                        self.coinModel = m;
                    }else{
                        m.isSelected = NO;
                    }
                }
                for (LCLotteryTicketWanFaModel *m in self.wanfaSelectArr) {
                    m.coin = self.coinModel.coin;
                }
               
                
                [subscriber sendNext:input];
                [subscriber sendCompleted];
                
                    
                return [RACDisposable disposableWithBlock:^{
                    
                }];
            }];
        }];
    }
    return _selectCoinCommand;
}
- (RACCommand *)customZhuMoneyCommand{
    if (_customZhuMoneyCommand == nil) {
        @weakify(self)
        _customZhuMoneyCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSString  * _Nullable input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                for (LCLotteryTicketCoinModel *m in self.dataModel.coinimg) {
                    
                        m.isSelected = NO;
                    
                }
                for (LCLotteryTicketWanFaModel *m in self.wanfaSelectArr) {
                    m.coin = input;
                }
                self.customZhuMoneyStr = input;
                [subscriber sendNext:input];
                [subscriber sendCompleted];
                
                    
                return [RACDisposable disposableWithBlock:^{
                    
                }];
            }];
        }];
    }
    return _customZhuMoneyCommand;
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
- (RACCommand *)kaijiangResultCommand{
    if (_kaijiangResultCommand == nil) {
        @weakify(self)
        _kaijiangResultCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id   _Nullable input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                self.isResultRequestSending = YES;
                LCLotteryTicketResultApi *api = [[LCLotteryTicketResultApi alloc] init];
                api.biaoshi = self.originModel.biaoshi;
                [[LCNetWorkManager manager] requestApi:api success:^(id  _Nullable result) {
                    self.isResultRequestSending = NO;
                    if ([result isKindOfClass:[NSDictionary class]]){
                        
                        NSDictionary *dic =result[@"info"];
                        LCLotteryTicketSQKJModel *model = [LCLotteryTicketSQKJModel mj_objectWithKeyValues:dic[@"jiang"]];
                        if(![model.expect isEqualToString:self.sqkj.expect] && [model.name isEqualToString:self.originModel.biaoshi]){
                            self.sqkj = model;
                            
                            
                        }
                        
                        
                       
                        [subscriber sendNext:result];
                        [subscriber sendCompleted];
                    } else{
                        
                        [subscriber sendError:[NSError errorWithDomain:KLanguage(@"数据加载失败，请稍后再试") code:500 userInfo:nil]];
                    }
                } failure:^(NSError * _Nullable error) {
                    self.isResultRequestSending = NO;
                    [subscriber sendError:error];
                }];
                    
                return [RACDisposable disposableWithBlock:^{
                    
                }];
            }];
        }];
    }
    _kaijiangResultCommand.allowsConcurrentExecution = NO;
    return _kaijiangResultCommand;
}
- (RACSubject *)kaijiangResultSubject{
    if (_kaijiangResultSubject == nil) {
        _kaijiangResultSubject = [RACSubject subject];
    }
    return _kaijiangResultSubject;
}
- (RACCommand *)socketInfoCommand{
    if (_socketInfoCommand == nil) {
        @weakify(self)
        _socketInfoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id   _Nullable input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
               
                LCLotteryTicketSocketInfoApi *api = [[LCLotteryTicketSocketInfoApi alloc] init];
                
                [[LCNetWorkManager manager] requestApi:api success:^(id  _Nullable result) {
                    self.isResultRequestSending = NO;
                    if ([result isKindOfClass:[NSDictionary class]]){
                        
                        NSDictionary *dic =result[@"info"];
                        NSString *socketUrl =  dic[@"chatserver"];
                        [[LCSocketManager shareManager] connetToSever:socketUrl delegate:self roomId:nil stream:nil];
                        
                       
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
   
    return _socketInfoCommand;
}
- (RACSubject *)socketInfoSubject{
    if (_socketInfoSubject == nil) {
        _socketInfoSubject = [RACSubject subject];
    }
    return _socketInfoSubject;
}
- (RACCommand *)closeSocketCommand{
    if (_closeSocketCommand == nil) {
        @weakify(self)
        _closeSocketCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id   _Nullable input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                LCUserInfoModel *model = [LCUserInfoManager shareManager].userInfo;
                NSArray *msgData =@[
                                    @{
                                        @"msg": @[
                                                @{
                                                    @"_method_":@"endgame",
                                                    @"caipiao":self.originModel.biaoshi,
                                                    @"token": model.token
                                                    }
                                                ],
                                        @"retcode":@"000000",
                                        @"retmsg":@"OK"
                                        }
                                    ];
                [[LCSocketManager shareManager] sendMessage:msgData eventName:@"game"];
                [[LCSocketManager shareManager] disconnect];
                 [subscriber sendNext:input];
                 [subscriber sendCompleted];
                
                    
                return [RACDisposable disposableWithBlock:^{
                    
                }];
            }];
        }];
    }
   
    return _closeSocketCommand;
}
@end
