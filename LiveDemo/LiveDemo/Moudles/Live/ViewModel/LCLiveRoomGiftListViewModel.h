//
//  LCLiveRoomGiftListViewModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/3/13.
//

#import "LCBaseViewModel.h"
#import "LCLiveGiftModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCLiveRoomGiftListViewModel : LCBaseViewModel
@property (nonatomic , assign) BOOL isBackPack;
@property (nonatomic , copy) NSString *roomId;
@property (nonatomic , copy) NSString *stream;
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , strong) RACCommand *balanceCommand;
@property (nonatomic , strong) RACSubject *balanceSubject;
@property (nonatomic , copy) NSString *balanceStr;
@property (nonatomic , strong,nullable) LCLiveGiftModel *selectGiftModel;
@property (nonatomic , strong) RACCommand *selectGiftCommand;
@property (nonatomic , strong) RACCommand *sendGiftCommand;
@property (nonatomic , strong) RACSubject *sendGiftSubject;

@end

NS_ASSUME_NONNULL_END
