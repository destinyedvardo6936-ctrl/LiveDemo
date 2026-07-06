//
//  LCQuotaViewModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/5/10.
//

#import "LCBaseViewModel.h"
#import "LCQuotaModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCQuotaViewModel : LCBaseViewModel
@property (nonatomic , strong ) NSMutableArray *dataArray;
@property (nonatomic , strong) LCBaseListApi *listApi;
@property (nonatomic , copy) NSString *balanceStr;
@property (nonatomic , strong) RACCommand *balanceCommand;
@property (nonatomic , strong) RACSubject *balanceSubject;
@property (nonatomic , strong) RACCommand *gameBalanceCommand;
@property (nonatomic , strong) RACSubject *gameBalanceSubject;
@property (nonatomic , strong) RACCommand *gameTransInCommand;
@property (nonatomic , strong) RACSubject *gameTransInSubject;
@property (nonatomic , strong) RACCommand *gameTransOutCommand;
@property (nonatomic , strong) RACSubject *gameTransOutSubject;
@end

NS_ASSUME_NONNULL_END
