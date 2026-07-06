//
//  LCWithDrawViewModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/23.
//

#import "LCBaseViewModel.h"
#import "LCWithDrawAccountModel.h"
#import "LCWithDrawProfitModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCWithDrawViewModel : LCBaseViewModel

@property (nonatomic , copy) NSString *type;
@property (nonatomic , copy) NSString *money;
@property (nonatomic , strong) LCWithDrawProfitModel *dataModel;
@property (nonatomic , strong) LCWithDrawAccountModel *accountModel;
@property (nonatomic , strong) RACCommand *coinCountCommand;
@property (nonatomic , strong) RACSubject *coinCountSubject;
@property (nonatomic , strong) RACCommand *withdrawCommand;
@property (nonatomic , strong) RACSubject *withdrawSubject;
@end

NS_ASSUME_NONNULL_END
