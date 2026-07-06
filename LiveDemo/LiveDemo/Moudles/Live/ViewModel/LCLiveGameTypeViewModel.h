//
//  LCLiveGameListViewModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/3/16.
//

#import "LCBaseViewModel.h"
#import "LCGameTypeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCLiveGameTypeViewModel : LCBaseViewModel
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , strong) NSMutableArray *titleArray;
@property (nonatomic , copy) NSString *balanceStr;
@property (nonatomic , strong) RACCommand *balanceCommand;
@property (nonatomic , strong) RACSubject *balanceSubject;
@end

NS_ASSUME_NONNULL_END
