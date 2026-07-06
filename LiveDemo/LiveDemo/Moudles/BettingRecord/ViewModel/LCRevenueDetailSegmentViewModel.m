//
//  LCRevenueDetailSegmentViewModel.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/15.
//

#import "LCRevenueDetailSegmentViewModel.h"

@implementation LCRevenueDetailSegmentViewModel
- (void)lc_initialize{
   
    self.currentIndex = 0;
    
//    [self lc_bindLoadSignal];
}
//- (LCBaseApi *)getLoadApi{
//    LCActivityTypeApi *api = [LCActivityTypeApi new];
//
//    return api;
//}
//- (id)dealWithLoadData:(id)result{
//    if ([result isKindOfClass:[NSDictionary class]]) {
//        NSDictionary *dic = result ;
//
////        [self.bannerArray removeAllObjects];
//
//        [self.channelDataArray removeAllObjects];
//        [self.channelDataArray addObjectsFromArray:[LCActivityTypeModel mj_objectArrayWithKeyValuesArray:dic[@"info"]]];
//        [self.channelTitleArray removeAllObjects];
//        for (LCActivityTypeModel *model in self.channelDataArray) {
//            [self.channelTitleArray addObject:model.name];
//        }
//
//    }
//
//
//    return result;
//}
//
//- (void)dealWithLoadError:(NSError *)error{
//
//}
#pragma mark---- 懒加载 ----
- (NSMutableArray *)channelDataArray{
    if (_channelDataArray == nil) {
        _channelDataArray = [NSMutableArray array];
        
        [_channelDataArray addObjectsFromArray: @[KLanguage(@"消费明细"),KLanguage(@"收入明细")] ];
    }
    return _channelDataArray;
}
//- (NSMutableArray *)channelTitleArray{
//    if (_channelTitleArray == nil) {
//        _channelTitleArray = [NSMutableArray array];
//        
//
//    }
//    return _channelTitleArray;
//}
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
@end
