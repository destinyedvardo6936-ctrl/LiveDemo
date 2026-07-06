//
//  LCWithDrawBindAccountViewModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/23.
//

#import "LCBaseViewModel.h"
#import "LCWithDrawAccountModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCWithDrawBindAccountViewModel : LCBaseViewModel
@property (nonatomic , strong) LCWithDrawAccountModel *dataModel;
@property (nonatomic , strong) RACCommand *addAccountCommand;
@property (nonatomic , strong) RACSubject *addAccountSubject;
@end

NS_ASSUME_NONNULL_END
