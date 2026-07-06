//
//  LCHomeSubSegmentsViewModel.m
//  LiveDemo
//
//  Created by mrgao on 2023/1/1.
//

#import "LCHomeSegmentsApi.h"
#import "LCHomeSubSegmentsViewModel.h"
#import "LCHomeGameSegmentApi.h"
#import "LCGameConfigManager.h"
#import "LCHomeNoticeApi.h"
#import "LCApplyAgentApi.h"
#import "LCMineUrlApi.h"
#import "LCLocalDataTools.h"

@implementation LCHomeSubSegmentsViewModel
- (void)lc_initialize {
    [self lc_bindLoadSignal];
    @weakify(self)
    WS(weakSelf)
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:LCGameStatusNot object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        if (![LCGameConfigManager shareManager].gameStatus){
            [weakSelf.gameArray removeAllObjects];
            [weakSelf.gameSubject sendNext:@(YES)];
        }
        
    }];
    [[[self.gameCommand.executionSignals switchToLatest] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.gameSubject sendNext:x];
    }];
    [[self.gameCommand.errors takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSError * _Nullable x) {
        @strongify(self)
        [self.gameSubject sendNext:x];
    }];
    [[[self.noticeCommand.executionSignals switchToLatest] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.noticeSubject sendNext:x];
    }];
    [[self.noticeCommand.errors takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSError * _Nullable x) {
        @strongify(self)
        [self.noticeSubject sendNext:x];
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
}

- (LCBaseApi *)getLoadApi {
    LCHomeSegmentsApi *api = [LCHomeSegmentsApi new];

    return api;
}

- (id)dealWithLoadData:(id)result {
    if ([result isKindOfClass:NSDictionary.class]) {
        NSDictionary *dic = result;
        NSArray *info = dic[@"info"];
        [self.channelDataArray removeAllObjects];
        [LCHomeSegmentModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"channelId":@"id"};
        }];
        LCHomeSegmentModel *model = [LCHomeSegmentModel new];
        model.name = self.currentFirstChannel;
        [self.channelDataArray addObject:model];
        [self.channelDataArray addObjectsFromArray:[LCHomeSegmentModel mj_objectArrayWithKeyValuesArray:info]];
        for (LCHomeSegmentModel *model in self.channelDataArray) {
            [self.channelTitleArray addObject:model.name];
        }
    }

    return result;
}

- (void)dealWithLoadError:(NSError *)error {
}

#pragma mark---- 懒加载 -----
- (NSMutableArray *)channelDataArray {
    if (_channelDataArray == nil) {
        _channelDataArray = [NSMutableArray array];
    }

    return _channelDataArray;
}

- (NSMutableArray *)channelTitleArray {
    if (_channelTitleArray == nil) {
        _channelTitleArray = [NSMutableArray array];
    }

    return _channelTitleArray;
}

- (NSMutableArray *)gameArray {
    if (_gameArray == nil) {
        _gameArray = [NSMutableArray array];
    }

    return _gameArray;
}
- (NSMutableArray *)noticeArray{
    if (_noticeArray == nil){
        _noticeArray = [NSMutableArray array];
//        [_noticeArray addObject:@"这里是轮播内容，循环播放"];
    }
    return _noticeArray;
}
- (RACCommand *)gameCommand{
    if (_gameCommand == nil){
        @weakify(self)
        _gameCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                LCHomeGameSegmentApi *api = [LCHomeGameSegmentApi new];
                [[LCNetWorkManager manager] requestApi:api success:^(id  _Nullable result) {
                    NSDictionary *info = result[@"info"];
                    if([info isKindOfClass:NSDictionary.class]){
                        if(info[@"topgamelist"]){
                            [self.gameArray removeAllObjects];
                            [self.gameArray addObjectsFromArray:[LCHomeGameChannelModel mj_objectArrayWithKeyValuesArray:info[@"topgamelist"]]];
                            
                        }
                        [subscriber sendNext:input];
                        [subscriber sendCompleted];
                    }else{
                        [subscriber sendError:[NSError errorWithDomain:KLanguage(@"请稍后再试") code:500 userInfo:nil]];
                       
                    }
                 
                } failure:^(NSError * _Nullable error) {
                    [subscriber sendError:error];
                    
                }];
                
                return [RACDisposable disposableWithBlock:^{
                    
                }];
            }];
        }];
    }
    return _gameCommand;
}
- (RACSubject *)gameSubject{
    if (_gameSubject == nil){
        _gameSubject = [RACSubject subject];
    }
    return _gameSubject;
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
                            if([dic[@"id"] intValue] == 1){
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
- (NSMutableArray *)urlModelArr{
    if (_urlModelArr == nil) {
        _urlModelArr = [NSMutableArray array];
    }
    return _urlModelArr;
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
@end
