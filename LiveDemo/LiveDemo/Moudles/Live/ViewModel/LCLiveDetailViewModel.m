//
//  LCLiveDetailViewModel.m
//  LiveDemo
//
//  Created by mrgao on 2022/12/2.
//

#import "LCLiveDetailViewModel.h"
#import "LCLiveDetailApi.h"
#import "LCLiveCheckRoomTypeApi.h"
#import "LCFollowApi.h"
#import "LCRecommendReplaceLiveApi.h"
#import "LCLotteryTicketResultApi.h"
#import "LCLiveChargeApi.h"
#import "LCLiveStopInfoApi.h"
#import "LCSendDanMuApi.h"
@implementation LCLiveDetailViewModel
- (void)lc_initialize{
    _dataModel = [LCLiveModel new];
    [self lc_bindLoadSignal];
    @weakify(self)
    [[[self.checkTypeCommand.executionSignals switchToLatest] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.checkTypeSubject sendNext:x];
    }];
    [[self.checkTypeCommand.errors takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSError * _Nullable x) {
        @strongify(self)
        [self.checkTypeSubject sendNext:x];
    }];
    [[[self.sendDanmuCommand.executionSignals switchToLatest] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.sendDanmuSubject sendNext:x];
    }];
    [[self.sendDanmuCommand.errors takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSError * _Nullable x) {
        @strongify(self)
        [self.sendDanmuSubject sendNext:x];
    }];
    [[[self.chargeCommand.executionSignals switchToLatest] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.chargeSubject sendNext:x];
    }];
    [[self.chargeCommand.errors takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSError * _Nullable x) {
        @strongify(self)
        [self.chargeSubject sendNext:x];
    }];
    [[[self.followCommand.executionSignals switchToLatest] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.followSubject sendNext:x];
    }];
    [[self.followCommand.errors takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSError * _Nullable x) {
        @strongify(self)
        [self.followSubject sendNext:x];
    }];
    [[[self.stopInfoCommand.executionSignals switchToLatest] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.stopInfoSubject sendNext:x];
    }];
    [[self.stopInfoCommand.errors takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSError * _Nullable x) {
        @strongify(self)
        [self.stopInfoSubject sendNext:x];
    }];
    [[[self.recommendLiveCommand.executionSignals switchToLatest] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.recommendLiveSubject sendNext:x];
    }];
    [[self.recommendLiveCommand.errors takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSError * _Nullable x) {
        @strongify(self)
        [self.recommendLiveSubject sendNext:x];
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:LCLiveLotteryTicketTimeCutDownNot object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        if([x.object isKindOfClass:NSDictionary.class]){
            NSDictionary *dic = x.object;
            if([dic[@"caipiao"] isEqualToString:self.origalModel.caipiao.biaoshi]){
                NSDictionary *timeDic = dic;
                self.lotteryTicketCutDownTimeStr =[NSString stringWithFormat:@"%ld", [timeDic[@"daojishi"] integerValue]];

            }
        }
        
    }];
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:LCLiveLotteryTicketKaijiangSocketFakeResultNot object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
      
        NSDictionary *dic = x.object;
        NSArray *arr = dic[@"ct"];
        for (NSDictionary *msgDic in arr) {
            LCChatMessageModel *messageModel = [LCChatMessageModel new];
            messageModel.type = 6;
            messageModel.content = msgDic[@"title"];
            [self.msgArray addObject:messageModel];
            [self.messageAddSubject sendNext:@(YES)];
        }
    }];
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:LCLiveLotteryTicketFakeGenTouSocketNot object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
 
        NSArray *arr = x.object;
        for (NSDictionary *msgDic in arr) {
            NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:msgDic];
            muDic[@"id"] = msgDic[@"wanfaxiid"];
            muDic[@"coin"] = msgDic[@"money"];
//            muDic[@"name"] = msgDic[@"value"];
            muDic[@"gameid"] = msgDic[@"caipiao_id"];
            muDic[@"gameName"] = msgDic[@"caipiao"];
//            muDic[@""] = 
            LCChatMessageModel *messageModel = [LCChatMessageModel new];
            messageModel.type = 4;
            messageModel.content = msgDic[@"title"];
            messageModel.lotteryTicketDic = @{@"wanfa":@[muDic],@"beishu":msgDic[@"beishu"]};
            [self.msgArray addObject:messageModel];
            [self.messageAddSubject sendNext:@(YES)];
        }
        

    }];
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:LCLiveLotteryTicketKaijiangSocketResultNot object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        NSDictionary *dic = x.object;
        LCLotteryTicketSQKJModel *model = [LCLotteryTicketSQKJModel mj_objectWithKeyValues:dic];
        if(![model.expect isEqualToString:self.sqkj.expect] && [model.name isEqualToString:self.origalModel.caipiao.biaoshi]){
            self.sqkj = [LCLotteryTicketSQKJModel mj_objectWithKeyValues:dic];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:LCLiveLotteryTicketKaijiangResultNot object:self.sqkj];
        }
       
        
    }];
}
- (LCBaseApi *)getLoadApi{
    LCLiveDetailApi *api = [LCLiveDetailApi new];
    api.liveuid = self.origalModel.uid;
    api.stream = self.origalModel.stream;
    return api;
}
- (id)dealWithLoadData:(id)result{
    if([result isKindOfClass:NSDictionary.class]){
        NSArray *a = result[@"info"];
        NSDictionary *dic = [a firstObject];
//        [self.origalModel.caipiao mj_setKeyValues:dic[@"caipiao"]];
        [LCLiveModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"userlists":@"LCLiveUserModel"};
        }];
        [LCLiveModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
               @"vip_type":@"vip.type",@"liang_name":@"liang.name",@"guard_type":@"guard.type"
                     };
        }];
        [LCLiveUserModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                @"userId":@"id",@"vip_type":@"vip.type",@"liang_name":@"liang.name"
                     };
        }];
        [self.dataModel mj_setKeyValues:dic];
        self.dataModel.uid = self.origalModel.uid;
        self.dataModel.stream = self.origalModel.stream;
    }
    return result;
}
- (void)dealWithLoadError:(NSError *)error{
    
}
- (void)setOrigalModel:(LCHomeListModel *)origalModel{
    _origalModel = origalModel;
//    [LCLiveArchorModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
//        return @{@"uid":@"id"};
//    }];
    self.archorModel = [LCLiveArchorModel mj_objectWithKeyValues:[_origalModel mj_keyValues]];
    self.archorModel.uid = _origalModel.uid;
}
#pragma mark---- 懒加载 ----
- (NSMutableArray *)msgArray{
    if(!_msgArray){
        _msgArray = [NSMutableArray array];
    }
    return _msgArray;
}
- (NSMutableArray *)recommendRoomArray{
    if(!_recommendRoomArray ){
        _recommendRoomArray = [NSMutableArray array];
    }
    return _recommendRoomArray;
}
- (NSMutableArray *)userAccessArray{
    if(!_userAccessArray){
        _userAccessArray = [NSMutableArray array];
    }
    return _userAccessArray;
}
- (RACCommand *)checkTypeCommand{
    if (_checkTypeCommand == nil) {
//        @weakify(self)
        _checkTypeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id   _Nullable input) {
//            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                LCLiveCheckRoomTypeApi *api = [[LCLiveCheckRoomTypeApi alloc] init];
                api.liveuid = self.origalModel.uid;
                api.stream = self.origalModel.stream;
                [[LCNetWorkManager manager] requestApi:api success:^(id  _Nullable result) {
                   
                    if ([result isKindOfClass:[NSDictionary class]]){
                        NSArray *a = result[@"info"];
                        NSDictionary *dic = [a firstObject];
                        self.roomTypeModel = [LCLiveRoomTypeModel mj_objectWithKeyValues:dic];

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
    return _checkTypeCommand;
}
- (RACSubject *)checkTypeSubject{
    if (_checkTypeSubject == nil) {
        _checkTypeSubject = [RACSubject subject];
    }
    return _checkTypeSubject;
}

- (RACCommand *)chargeCommand{
    if (_chargeCommand == nil) {
//        @weakify(self)
        _chargeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id   _Nullable input) {
//            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                LCLiveChargeApi *api = [[LCLiveChargeApi alloc] init];
                api.roomId = self.origalModel.uid;
                api.stream = self.origalModel.stream;
                [[LCNetWorkManager manager] requestApi:api success:^(id  _Nullable result) {
                   
                    if ([result isKindOfClass:[NSDictionary class]]){
                        NSArray *a = result[@"info"];
                        NSDictionary *dic = [a firstObject];
                        NSString *coin = dic[@"coin"];
                        LCUserInfoModel *model = [LCUserInfoManager shareManager].userInfo;
                        model.coin = coin;
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
    return _chargeCommand;
}
- (RACSubject *)chargeSubject{
    if (_chargeSubject == nil) {
        _chargeSubject = [RACSubject subject];
    }
    return _chargeSubject;
}

- (RACCommand *)followCommand{
    if (_followCommand == nil) {
        @weakify(self)
        _followCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id   _Nullable input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                LCFollowApi *api = [[LCFollowApi alloc] init];
                api.userId = self.archorModel.uid;
//                api.postId = input.postId;
                [[LCNetWorkManager manager] requestApi:api success:^(id  _Nullable result) {
                   
                    if ([result isKindOfClass:[NSDictionary class]]){
                        
                        self.archorModel.isAttention = self.archorModel.isAttention.boolValue?@"0":@"1";

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
- (RACCommand *)stopInfoCommand{
    if (_stopInfoCommand == nil) {
        @weakify(self)
        _stopInfoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id   _Nullable input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                LCLiveStopInfoApi *api = [[LCLiveStopInfoApi alloc] init];
                api.stream = self.origalModel.stream;
//                api.postId = input.postId;
                [[LCNetWorkManager manager] requestApi:api success:^(id  _Nullable result) {
                   
                    if ([result isKindOfClass:[NSDictionary class]]){
                        
                        NSDictionary *dic = result[@"info"];

                        [subscriber sendNext:dic];
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
    return _stopInfoCommand;
}
- (RACSubject *)stopInfoSubject{
    if (_stopInfoSubject == nil) {
        _stopInfoSubject = [RACSubject subject];
    }
    return _stopInfoSubject;
}
- (RACCommand *)recommendLiveCommand{
    if (_recommendLiveCommand == nil) {
//        @weakify(self)
        _recommendLiveCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id   _Nullable input) {
//            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                LCRecommendReplaceLiveApi *api = [LCRecommendReplaceLiveApi new];
                [[LCNetWorkManager manager] requestApi:api success:^(id  _Nullable result) {
                    if ([result isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *dic = result ;
                       
                       
                        if (dic[@"info"]){
//                            [self.recommendArray removeAllObjects];
                            [LCGameListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                                return @{@"modelId":@"id"};
                            }];
                            NSArray *arr = [LCHomeListModel mj_objectArrayWithKeyValuesArray:dic[@"info"]];
                            [self.recommendRoomArray removeAllObjects];
                            [self.recommendRoomArray addObjectsFromArray:arr];
                            [subscriber sendNext:arr];
                            [subscriber sendCompleted];
                            
                        }else{
                            [subscriber sendError:[NSError errorWithDomain:KLanguage(@"数据加载失败，请稍后再试")  code:500 userInfo:nil]];
                        }
                        
                        
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
    return _recommendLiveCommand;
}
- (RACSubject *)recommendLiveSubject{
    if (_recommendLiveSubject == nil) {
        _recommendLiveSubject = [RACSubject subject];
    }
    return _recommendLiveSubject;
}
- (RACSubject *)messageAddSubject{
    if(!_messageAddSubject){
        _messageAddSubject = [RACSubject subject];
    }
    return _messageAddSubject;
}
- (RACSubject *)disConnectSubject{
    if(!_disConnectSubject){
        _disConnectSubject = [RACSubject subject];
    }
    return _disConnectSubject;
}
- (RACSubject *)roomCloseByAdminSubject{
    if(!_roomCloseByAdminSubject){
        _roomCloseByAdminSubject = [RACSubject subject];
    }
    return _roomCloseByAdminSubject;
}
- (RACSubject *)liveEndSubject{
    if(!_liveEndSubject){
        _liveEndSubject = [RACSubject subject];
    }
    return _liveEndSubject;
}
- (RACSubject *)liveTypeChangeSubject{
    if(!_liveTypeChangeSubject){
        _liveTypeChangeSubject = [RACSubject subject];
    }
    return _liveTypeChangeSubject;
}

- (RACSubject *)audienceChangeSubject{
    if(!_audienceChangeSubject){
        _audienceChangeSubject = [RACSubject subject];
    }
    return _audienceChangeSubject;
}
- (RACSubject *)userAccessSubject{
    if(!_userAccessSubject){
        _userAccessSubject = [RACSubject subject];
    }
    return _userAccessSubject;
}
- (RACSubject *)userLeaveSubject{
    if(!_userLeaveSubject){
        _userLeaveSubject = [RACSubject subject];
    }
    return _userLeaveSubject;
}

- (RACSubject *)adminLevelSubject{
    if(!_adminLevelSubject){
        _adminLevelSubject = [RACSubject subject];
    }
    return _adminLevelSubject;
}
- (RACSubject *)adminLevelCancelSubject{
    if(!_adminLevelCancelSubject){
        _adminLevelCancelSubject = [RACSubject subject];
    }
    return _adminLevelCancelSubject;
}
- (RACSubject *)shutUpSubject{
    if(!_shutUpSubject){
        _shutUpSubject = [RACSubject subject];
    }
    return _shutUpSubject;
}
- (RACSubject *)kickUserSubject{
    if(!_kickUserSubject){
        _kickUserSubject = [RACSubject subject];
    }
    return _kickUserSubject;
}
- (RACCommand *)sendDanmuCommand{
    if (_sendDanmuCommand == nil) {
//        @weakify(self)
        _sendDanmuCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSString *   _Nullable input) {
//            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                LCSendDanMuApi *api = [LCSendDanMuApi new];
                api.liveuid = self.origalModel.uid;
                api.stream = self.origalModel.stream;
                api.content = input;
                [[LCNetWorkManager manager] requestApi:api success:^(id  _Nullable result) {
                    if ([result isKindOfClass:[NSDictionary class]]) {
                        NSArray *a =result[@"info"];
                        NSDictionary *dic = [a firstObject];
                       
                       
                        if (dic){
//                            [self.recommendArray removeAllObjects];
                            LCUserInfoModel *model = [LCUserInfoManager shareManager].userInfo;
                            model.coin = [NSString stringWithFormat:@"%ld",[dic[@"coin"]integerValue]];
                            model.level = [NSString stringWithFormat:@"%ld",[dic[@"level"]integerValue]];
                            [[LCUserInfoManager shareManager] updateUserInfo:model];
                            [subscriber sendNext:dic[@"barragetoken"]];
                            [subscriber sendCompleted];
                            
                        }else{
                            [subscriber sendError:[NSError errorWithDomain:KLanguage(@"数据加载失败，请稍后再试")  code:500 userInfo:nil]];
                        }
                        
                        
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
    return _sendDanmuCommand;
}
- (RACSubject *)sendDanmuSubject{
    if(!_sendDanmuSubject){
        _sendDanmuSubject = [RACSubject subject];
    }
    return _sendDanmuSubject;
}
- (RACSubject *)danmuSubject{
    if(!_danmuSubject){
        _danmuSubject = [RACSubject subject];
    }
    return _danmuSubject;
}
- (RACSubject *)giftAllPlatformSubject{
    if(!_giftAllPlatformSubject){
        _giftAllPlatformSubject = [RACSubject subject];
    }
    return _giftAllPlatformSubject;
}
- (RACSubject *)sendGiftSubject{
    if(!_sendGiftSubject){
        _sendGiftSubject = [RACSubject subject];
    }
    return _sendGiftSubject;
}
- (RACSubject *)lightSubject{
    if(!_lightSubject){
        _lightSubject = [RACSubject subject];
    }
    return _lightSubject;
}
- (RACSubject *)addCoinSubject{
    if(!_addCoinSubject){
        _addCoinSubject = [RACSubject subject];
    }
    return _addCoinSubject;
}
- (RACSubject *)buyGuardSubject{
    if(!_buyGuardSubject){
        _buyGuardSubject = [RACSubject subject];
    }
    return _buyGuardSubject;
}
- (RACSubject *)gameXiaZhuSubject{
    if(!_gameXiaZhuSubject){
        _gameXiaZhuSubject = [RACSubject subject];
    }
    return _gameXiaZhuSubject;
}
- (RACSubject *)gameKaiJiangSubject{
    if(!_gameKaiJiangSubject){
        _gameKaiJiangSubject = [RACSubject subject];
    }
    return _gameKaiJiangSubject;
}
- (RACSubject *)gameTimeSubject{
    if(!_gameTimeSubject){
        _gameTimeSubject = [RACSubject subject];
    }
    return _gameTimeSubject;
}
- (RACSubject *)winningPrizeSubject{
    if(!_winningPrizeSubject){
        _winningPrizeSubject = [RACSubject subject];
    }
    return _winningPrizeSubject;
}

@end
