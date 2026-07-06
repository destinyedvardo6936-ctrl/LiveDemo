//
//  LCHomeSegmentsViewModel.h
//  liveCommon
//
//  Created by mrgao on 2022/9/29.
//

#import "LCBaseViewModel.h"
#import "LCVersionModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCHomeSegmentsViewModel : LCBaseViewModel
@property (nonatomic , strong) NSMutableArray *channelDataArray;

@property (nonatomic , assign) NSInteger currentIndex;
@property (nonatomic , strong) RACCommand *changeChannelIndexCommend;
@property (nonatomic , copy) NSString *video_status;
@property (nonatomic , copy) NSString *shortvideo_status;

@property (nonatomic , strong) LCVersionModel *versionModel;
@property (nonatomic , strong) RACCommand *versionCommand;
@property (nonatomic , strong) RACSubject *versionSubject;
@end

NS_ASSUME_NONNULL_END
