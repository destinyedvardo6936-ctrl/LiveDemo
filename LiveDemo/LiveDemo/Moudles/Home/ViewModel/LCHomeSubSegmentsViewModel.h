//
//  LCHomeSubSegmentsViewModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/1/1.
//

#import "LCBaseViewModel.h"
#import "LCHomeSegmentModel.h"
#import "LCNoticeModel.h"
#import "LCHomeGameChannelModel.h"
#import "LCMineUrlModel.h"
#import "LCUrlListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCHomeSubSegmentsViewModel : LCBaseViewModel
@property (nonatomic , strong) NSMutableArray *urlModelArr;
@property (nonatomic , copy) NSString *currentFirstChannel;
@property (nonatomic , strong) NSMutableArray *channelDataArray;
@property (nonatomic , strong) NSMutableArray *channelTitleArray;
@property (nonatomic , strong) NSMutableArray *gameArray;

@property (nonatomic , strong) NSMutableArray *noticeArray;//公告

@property (nonatomic , strong) RACCommand *urlCommand;
@property (nonatomic , strong) RACSubject *urlSubject;
@property (nonatomic , strong) RACCommand *gameCommand;
@property (nonatomic , strong) RACSubject *gameSubject;
@property (nonatomic , strong) RACCommand *noticeCommand;
@property (nonatomic , strong) RACSubject *noticeSubject;
@property (nonatomic , strong) RACCommand *applyAgentCommand;
@property (nonatomic , strong) RACSubject *applyAgentSubject;
@end

NS_ASSUME_NONNULL_END
