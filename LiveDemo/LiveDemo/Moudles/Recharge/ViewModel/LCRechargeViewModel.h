//
//  LCRechargeViewModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/15.
//

#import "LCBaseViewModel.h"
#import "LCRechargeTypeModel.h"
#import "LCRechargeMoneyModel.h"
#import "LCRechargeConnetPersonModel.h"
#import "LCRechargeSubTypeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCRechargeViewModel : LCBaseViewModel
@property (nonatomic , strong) LCRechargeTypeModel *dataModel;
@property (nonatomic , strong) NSMutableArray *moneyArray;
@property (nonatomic , strong) NSMutableArray *personArray;
@property (nonatomic , strong) NSMutableArray *subPayWayArray;

@property (nonatomic , strong) LCRechargeSubTypeModel *selectSubTypeModel;
@property (nonatomic , strong) LCRechargeMoneyModel *selectMoneyModel;
@property (nonatomic , strong) LCRechargeConnetPersonModel *selectPersonModel;

@property (nonatomic , strong) RACCommand *bankOrVirtualSubmitCommand;
@property (nonatomic , strong) RACSubject *bankOrVirtualSubmitSubject;
@property (nonatomic , strong) RACCommand *otherSubmitCommand;
@property (nonatomic , strong) RACSubject *otherSubmitSubject;
@end

NS_ASSUME_NONNULL_END
