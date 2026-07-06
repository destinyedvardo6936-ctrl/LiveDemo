//
//  LCShortVideoChannelViewModel.m
//  LiveDemo
//
//  Created by mrgao on 2023/5/8.
//

#import "LCShortVideoChannelViewModel.h"

@implementation LCShortVideoChannelViewModel
- (void)lc_initialize {
    [self.channelDataArray addObjectsFromArray:[LCConfigManager shareManager].configModel.videoclass];
    for (NSDictionary *dic in self.channelDataArray) {
        [self.channelTitleArray addObject:dic[@"name"]];
    }
    
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
@end
