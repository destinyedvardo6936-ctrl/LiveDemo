//
//  LCMineViewModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/1/4.
//

#import "LCBaseViewModel.h"
#import "LCMineOptionModel.h"
#import "LCBannerModel.h"
#import "LCUrlListModel.h"
#import "LCMessageListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCMineViewModel : LCBaseViewModel
@property (nonatomic , strong) NSMutableArray *urlModelArr;

@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , strong) LCUserInfoModel *dataModel;
@property (nonatomic , strong) NSMutableArray *bannerArray;
@property (nonatomic , strong) RACCommand *bannerCommand;
@property (nonatomic , strong) RACSubject *bannerSubject;
@property (nonatomic , strong) RACCommand *urlCommand;
@property (nonatomic , strong) RACSubject *urlSubject;

@property (nonatomic , strong) RACCommand *messageCommand;
@property (nonatomic , strong) RACSubject *messageSubject;
@property (nonatomic , strong) LCMessageListModel *messageModel;

@property (nonatomic , strong) RACCommand *applyAgentCommand;
@property (nonatomic , strong) RACSubject *applyAgentSubject;

//@property (nonatomic , copy) NSString *kefuUrl;
//@property (nonatomic , strong) RACCommand *kefuUrlCommand;
//@property (nonatomic , strong) RACSubject *kefuUrlSubject;
@end

NS_ASSUME_NONNULL_END
