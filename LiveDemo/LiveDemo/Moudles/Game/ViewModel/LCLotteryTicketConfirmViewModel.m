//
//  LCLotteryTicketConfirmViewModel.m
//  LiveDemo
//
//  Created by mrgao on 2023/3/22.
//

#import "LCLotteryTicketConfirmViewModel.h"
#import "LCLotteryTicketXiazhuApi.h"
#import "LCLotteryTicketResultApi.h"
@implementation LCLotteryTicketConfirmViewModel
- (void)lc_initialize{
    self.balanceStr = [LCUserInfoManager shareManager].userInfo.coin;
    @weakify(self)
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:LCGameLotteryTicketBeishuSelectNot object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        LCLotteryTicketBeishuModel *beishuModel = x.object;
        for (LCLotteryTicketBeishuModel *m in self.beishuArr) {
            if([m isEqual:beishuModel]){
                m.isSelected = YES;
                self.beishuModel = m;
            }else{
                m.isSelected = NO;
            }
        }
        NSInteger totalPrice = 0;

        for (LCLotteryTicketWanFaModel *m in self.wanfaSelectArr) {
            m.coin = [NSString stringWithFormat:@"%ld",m.coin.integerValue * self.beishuModel.name.integerValue];
            totalPrice += m.coin.integerValue;
        }

        NSString *totalPriceStr = [NSString stringWithFormat:@"%ld", totalPrice];
        self.totalMoney = totalPriceStr;
        
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:LCGameLotteryTicketWanfaDeleteNot object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        LCLotteryTicketWanFaModel *wanfaModel = x.object;
        if(wanfaModel.isSelected){
            wanfaModel.isSelected =  NO;
        }
        
        if([self.wanfaSelectArr containsObject:wanfaModel]){
            [self.wanfaSelectArr removeObject:wanfaModel];
        }
        self.xiazhuCount = self.wanfaSelectArr.count;
        NSInteger totalPrice = 0;

        for (LCLotteryTicketWanFaModel *m in self.wanfaSelectArr) {
            totalPrice += m.coin.integerValue;
        }

        NSString *totalPriceStr = [NSString stringWithFormat:@"%ld", totalPrice];
        self.totalMoney = totalPriceStr;
        [self.loadDataFinishLoadSubject sendNext:@(YES)];
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:LCLiveLotteryTicketTimeCutDownNot object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        if([x.object isKindOfClass:NSDictionary.class]){
            NSDictionary *dic = x.object;
            LCLotteryTicketWanFaModel *firstModel = [self.wanfaSelectArr firstObject];
         
            if([dic[@"caipiao"] isEqualToString:firstModel.biaoshi]){
                NSDictionary *timeDic = dic;
                self.countDownTime =[NSString stringWithFormat:@"%ld", [timeDic[@"daojishi"] integerValue]];
                if([timeDic[@"daojishi"] integerValue] <= 10){
                    self.isFP = YES;
                }else{
                    self.isFP = NO;
                }
                if([timeDic[@"daojishi"] integerValue] ==1){
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if(!self.isResultRequestSending){
                            [self.kaijiangResultCommand execute:@(YES)];
                        }
                    });
//                    if(!self.isResultRequestSending){
//                        [self.kaijiangResultCommand execute:@(YES)];
//                    }else{
//                        
//                    }
                    
                }
                NSString *nowQihao = timeDic[@"benqihao"];
                
                    self.qihao = nowQihao;
                
//                NSString *lastnowQihao = timeDic[@"lastqihao"];
//                if(![lastnowQihao isEqualToString:self.lastQihaoStr]){
//                    self.lastQihaoStr = lastnowQihao;
//                }
            }
        }
        
        
    }];
    [[[self.xiazhuCommand.executionSignals switchToLatest] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.xiazhuSubject sendNext:x];
    }];
    
    [[self.xiazhuCommand.errors takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSError * _Nullable x) {
        @strongify(self)
        [self.xiazhuSubject sendNext:x];
    }];
    [[[self.kaijiangResultCommand.executionSignals switchToLatest] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.kaijiangResultSubject sendNext:x];
    }];
    
    [[self.kaijiangResultCommand.errors takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSError * _Nullable x) {
        @strongify(self)
        [self.kaijiangResultSubject sendNext:x];
    }];
}
- (void)setWanfaSelectArr:(NSMutableArray *)wanfaSelectArr{
    _wanfaSelectArr = wanfaSelectArr;
    self.xiazhuCount = _wanfaSelectArr.count;
    NSInteger totalPrice = 0;

    for (LCLotteryTicketWanFaModel *m in _wanfaSelectArr) {
        totalPrice += m.coin.integerValue;
    }

    NSString *totalPriceStr = [NSString stringWithFormat:@"%ld", totalPrice];
    self.totalMoney = totalPriceStr;
}

#pragma mark---- 懒加载 ----
- (NSMutableArray *)beishuArr{
    if(_beishuArr == nil){
        _beishuArr = [NSMutableArray array];
    
        NSArray *temp = @[@"1",@"2",@"5",@"10",@"20"];
        for (NSString *name in temp) {
            LCLotteryTicketBeishuModel *model = [LCLotteryTicketBeishuModel new];
            model.name = name;
            [_beishuArr addObject:model];
        }
        self.beishuModel = [_beishuArr firstObject];
        self.beishuModel.isSelected = YES;
//        [_beishuArr addObjectsFromArray: @[KLanguage(@"1倍"),KLanguage(@"2倍"),KLanguage(@"5倍"),KLanguage(@"10倍"),KLanguage(@"20倍")]];
    }
    return _beishuArr;
}
- (RACCommand *)customMoneyCommand{
    if (_customMoneyCommand == nil) {
        @weakify(self)
        _customMoneyCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(RACTuple  * _Nullable input) {
            NSString *money = input[0];
            LCLotteryTicketWanFaModel *model = input[1];
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                model.coin = self.beishuModel ? [NSString stringWithFormat:@"%ld",self.beishuModel.name.integerValue * money.integerValue]:money;
                NSInteger totalPrice = 0;

                for (LCLotteryTicketWanFaModel *m in self.wanfaSelectArr) {
                    totalPrice += m.coin.integerValue;
                }

                NSString *totalPriceStr = [NSString stringWithFormat:@"%ld", totalPrice];
                self.totalMoney = totalPriceStr;
                [subscriber sendNext:input];
                [subscriber sendCompleted];
                
                    
                return [RACDisposable disposableWithBlock:^{
                    
                }];
            }];
        }];
    }
    return _customMoneyCommand;
}
- (RACCommand *)selectBeishuCommand{
    if (_selectBeishuCommand == nil) {
        @weakify(self)
        _selectBeishuCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSString  * _Nullable input) {
            
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                for (LCLotteryTicketBeishuModel *m in self.beishuArr) {
                    if([m.name isEqualToString:input]){
                        m.isSelected = YES;
                        self.beishuModel = m;
                    }else{
                        m.isSelected = NO;
                    }
                }
                [subscriber sendNext:input];
                [subscriber sendCompleted];
                
                    
                return [RACDisposable disposableWithBlock:^{
                    
                }];
            }];
        }];
    }
    return _selectBeishuCommand;
}
- (RACSubject *)xiazhuSubject{
    if (_xiazhuSubject == nil){
        _xiazhuSubject = [RACSubject subject];
    }
    return _xiazhuSubject;
}
- (RACCommand *)xiazhuCommand{
    if (_xiazhuCommand == nil) {
        @weakify(self)
        _xiazhuCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id   _Nullable input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                NSMutableArray *resultArr = [NSMutableArray array];
                for (LCLotteryTicketWanFaModel *model in self.wanfaSelectArr) {
                    LCLotteryTicketXiazhuApi *api = [[LCLotteryTicketXiazhuApi alloc] init];
                    api.biaoshi = model.biaoshi;
                    api.wanfaxiid = model.modelId;
                    api.zhuboid = self.zhuboId;
                    api.zhushu = @"1";
                    api.beishu = self.beishuModel.name.length?self.beishuModel.name:@"1";
                    api.money = model.coin;
                    api.value = model.name;
                    [[LCNetWorkManager manager] requestApi:api success:^(id  _Nullable result) {
                        [resultArr addObject:result];
                        if(resultArr.count == self.wanfaSelectArr.count){
                            NSArray *wanfa = [LCLotteryTicketWanFaModel mj_keyValuesArrayWithObjectArray:self.wanfaSelectArr];
                            NSDictionary *dic = @{@"uid":[LCUserInfoManager shareManager].userInfo.ID,@"token":[LCUserInfoManager shareManager].userInfo.token,@"zhuboid":self.zhuboId ?  self.zhuboId: @"",@"name":model.biaoshi,@"gameId":model.gameid,@"biaoshi":model.biaoshi,@"title":model.gameName,@"wanfa":wanfa,@"zhushu":[NSString stringWithFormat:@"%ld",self.xiazhuCount],@"beishu":self.beishuModel.name.length?self.beishuModel.name:@"1",@"allmoney":self.totalMoney};
                            
                            [subscriber sendNext:dic];
                            [subscriber sendCompleted];
                        }
                        
                    } failure:^(NSError * _Nullable error) {
                        [resultArr addObject:error];
                        if(resultArr.count == self.wanfaSelectArr.count){
                            [subscriber sendError:error];
                        }

                    }];
                }


                
                return [RACDisposable disposableWithBlock:^{
                    
                }];
            }];
        }];
    }
    return _xiazhuCommand;
}
- (RACCommand *)kaijiangResultCommand{
    if (_kaijiangResultCommand == nil) {
        @weakify(self)
        _kaijiangResultCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id   _Nullable input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                self.isResultRequestSending = YES;
                LCLotteryTicketResultApi *api = [[LCLotteryTicketResultApi alloc] init];
                LCLotteryTicketWanFaModel *model = [self.wanfaSelectArr firstObject];
                api.biaoshi = model.biaoshi;
                
                [[LCNetWorkManager manager] requestApi:api success:^(id  _Nullable result) {
                    self.isResultRequestSending = NO;
                    if ([result isKindOfClass:[NSDictionary class]]){
                        
                        NSDictionary *dic =result[@"info"];
                        LCLotteryTicketSQKJModel *model = [LCLotteryTicketSQKJModel mj_objectWithKeyValues:dic[@"jiang"]];
                        if(![model.expect isEqualToString:self.sqkj.expect] ){
                            self.sqkj = [LCLotteryTicketSQKJModel mj_objectWithKeyValues:dic];
                            
                            
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
//    _kaijiangResultCommand.allowsConcurrentExecution = NO;
    return _kaijiangResultCommand;
}
- (RACSubject *)kaijiangResultSubject{
    if (_kaijiangResultSubject == nil) {
        _kaijiangResultSubject = [RACSubject subject];
    }
    return _kaijiangResultSubject;
}
@end
