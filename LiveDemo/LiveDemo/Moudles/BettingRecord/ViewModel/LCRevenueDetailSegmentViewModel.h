//
//  LCRevenueDetailSegmentViewModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/15.
//

#import "LCBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCRevenueDetailSegmentViewModel : LCBaseViewModel
@property (nonatomic , strong) NSMutableArray *channelDataArray;
@property (nonatomic , assign) NSInteger currentIndex;
@property (nonatomic , strong) RACCommand *changeChannelIndexCommend;
@end

NS_ASSUME_NONNULL_END
