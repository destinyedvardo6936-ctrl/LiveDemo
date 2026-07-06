//
//  LCGameCenterViewModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/3/17.
//

#import "LCBaseViewModel.h"
#import "LCGameTypeModel.h"
#import "LCNoticeModel.h"
#import "LCBannerModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCGameCenterViewModel : LCBaseViewModel
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , strong) NSMutableArray *bannerArray;
@property (nonatomic , strong) NSMutableArray *noticeArray;

@property (nonatomic , strong) RACCommand *bannerCommand;
@property (nonatomic , strong) RACSubject *bannerSubject;
@property (nonatomic , strong) LCGameTypeModel *selectTypeModel;

@property (nonatomic , strong) RACCommand *thirdGameTypeCommand;
@property (nonatomic , strong) RACSubject *thirdGameTypeSubject;

@property (nonatomic , strong) RACCommand *gameListCommand;
@property (nonatomic , strong) RACSubject *gameListSubject;

@property (nonatomic , copy) NSString *balanceStr;
@property (nonatomic , strong) RACCommand *balanceCommand;
@property (nonatomic , strong) RACSubject *balanceSubject;


@property (nonatomic , strong) RACCommand *huishouCommand;
@property (nonatomic , strong) RACSubject *huishouSubject;

@property (nonatomic , strong) RACCommand *noticeCommand;
@property (nonatomic , strong) RACSubject *noticeSubject;


@property (nonatomic , strong) RACCommand *enterThirdGameCommand;
@property (nonatomic , strong) RACSubject *enterThirdGameSubject;

@end

NS_ASSUME_NONNULL_END
