//
//  LCRechargeViewModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/1/4.
//

#import "LCBaseViewModel.h"
#import "LCRechargeTypeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCRechargeTypeViewModel : LCBaseViewModel
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , assign) NSInteger currentIndex;
@property (nonatomic , strong) RACCommand *changeSelectIndexCommend;
@property (nonatomic , strong) NSMutableArray *noticeArray;//公告
@property (nonatomic , strong) RACCommand *noticeCommand;
@property (nonatomic , strong) RACSubject *noticeSubject;

@property (nonatomic , copy) NSString *balanceStr;
@property (nonatomic , strong) RACCommand *balanceCommand;
@property (nonatomic , strong) RACSubject *balanceSubject;
@end

NS_ASSUME_NONNULL_END
