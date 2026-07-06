//
//  LCShortVideoChannelViewModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/5/8.
//

#import "LCBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCShortVideoChannelViewModel : LCBaseViewModel

@property (nonatomic , strong) NSMutableArray *channelDataArray;
@property (nonatomic , strong) NSMutableArray *channelTitleArray;
@end

NS_ASSUME_NONNULL_END
