//
//  LCHomeSegmentsViewModel.m
//  liveCommon
//
//  Created by mrgao on 2022/9/29.
//

#import "LCHomeSegmentsViewModel.h"
#import "LCHomeSegmentsApi.h"
#import "LCHomeSegmentsViewModel.h"
#import "LCHomeChannelModel.h"
#import "LCGameConfigManager.h"
#import "LCVideoSwichApi.h"
#import "LCCheckVersionApi.h"
@implementation LCHomeSegmentsViewModel
- (void)lc_initialize{
    [self lc_bindLoadSignal];
    self.currentIndex = 1;
    WS(weakSelf)
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:LCGameStatusNot object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        [weakSelf.channelDataArray removeAllObjects];
        [weakSelf.channelDataArray addObjectsFromArray:[LCGameConfigManager shareManager].gameStatus ?@[KLanguage(@"关注"),KLanguage(@"推荐"),KLanguage(@"热门"),KLanguage(@"附近"),KLanguage(@"游戏")]:@[KLanguage(@"关注"),KLanguage(@"推荐"),KLanguage(@"热门"),KLanguage(@"附近")]];
        if([weakSelf.shortvideo_status boolValue]){
            [weakSelf.channelDataArray addObject:KLanguage(@"短视频")];
        }
        if([weakSelf.video_status boolValue]){
            [weakSelf.channelDataArray addObject:KLanguage(@"视频")];
        }
        
    }];
    @weakify(self)
   
    [[[self.versionCommand.executionSignals switchToLatest] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.versionSubject sendNext:x];
    }];
    [[self.versionCommand.errors takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSError * _Nullable x) {
        @strongify(self)
        [self.versionSubject sendNext:x];
    }];
//    @weakify(self)
//    [[[self.changeChannelIndexCommend.executionSignals switchToLatest] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
//        @strongify(self)
//       
//
//    }];
}
- (LCBaseApi *)getLoadApi{
    LCVideoSwichApi *api = [LCVideoSwichApi new];
    return api;
}
- (id)dealWithLoadData:(id)result{
    if([result isKindOfClass:NSDictionary.class]){
        NSDictionary *dic = result[@"info"];
        self.video_status = minstr(dic[@"video_status"]);
        self.shortvideo_status = minstr(dic[@"shortvideo_status"]);
        if([self.shortvideo_status boolValue] && ![self.channelDataArray containsObject:KLanguage(@"短视频")]){
            [self.channelDataArray addObject:KLanguage(@"短视频")];
        }
        if([self.video_status boolValue] && ![self.channelDataArray containsObject:KLanguage(@"视频")]){
            [self.channelDataArray addObject:KLanguage(@"视频")];
        }
    }
    return result;
}
- (void)dealWithLoadError:(NSError *)error{
    
}
#pragma mark---- 懒加载 ----
- (NSMutableArray *)channelDataArray{
    if (_channelDataArray == nil) {
        _channelDataArray = [NSMutableArray array];
        
        [_channelDataArray addObjectsFromArray:[LCGameConfigManager shareManager].gameStatus ?@[KLanguage(@"关注"),KLanguage(@"推荐"),KLanguage(@"热门"),KLanguage(@"附近"),KLanguage(@"游戏")]:@[KLanguage(@"关注"),KLanguage(@"推荐"),KLanguage(@"热门"),KLanguage(@"附近")]];
    }
    return _channelDataArray;
}
- (RACCommand *)changeChannelIndexCommend{
    if (_changeChannelIndexCommend == nil) {
        @weakify(self)
        _changeChannelIndexCommend = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(NSNumber  *_Nullable input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                if (input.integerValue < self.channelDataArray.count && input.integerValue >= 0) {
                   
                        self.currentIndex = input.integerValue;
                        
                    
                   
                }
                [subscriber sendNext:input];
                [subscriber sendCompleted];
                return [RACDisposable disposableWithBlock:^{
                    
                }];
            }];
        }];
    }
    return _changeChannelIndexCommend;
}

- (RACCommand *)versionCommand{
    if (_versionCommand == nil){
        @weakify(self)
        _versionCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                LCCheckVersionApi *api = [LCCheckVersionApi new];
                [[LCNetWorkManager manager] requestApi:api success:^(id  _Nullable result) {
                    if ([result isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *dic = result[@"info"];
                        self.versionModel = [LCVersionModel mj_objectWithKeyValues:dic];
//                        [self.versionModel mj_setKeyValues:dic];
                       
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
    return _versionCommand;
}
- (RACSubject *)versionSubject{
    if (_versionSubject == nil){
        _versionSubject = [RACSubject subject];
    }
    return _versionSubject;
}
@end
