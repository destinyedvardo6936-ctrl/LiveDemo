//
//  LCActivitySegmentViewModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/1/1.
//

#import "LCBaseViewModel.h"
#import "LCActivityTypeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCActivitySegmentViewModel : LCBaseViewModel
@property (nonatomic , strong) NSMutableArray *channelDataArray;
@property (nonatomic , strong) NSMutableArray *channelTitleArray;
@property (nonatomic , assign) NSInteger currentIndex;
@property (nonatomic , strong) RACCommand *changeChannelIndexCommend;
@end

NS_ASSUME_NONNULL_END
