//
//  LCLiveGameListViewModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/3/18.
//

#import "LCBaseViewModel.h"
#import "LCGameTypeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCLiveGameListViewModel : LCBaseViewModel

@property (nonatomic , strong) LCGameTypeModel *typeModel;
@property (nonatomic , strong) RACCommand *thirdGameTypeCommand;
@property (nonatomic , strong) RACSubject *thirdGameTypeSubject;
@property (nonatomic , strong) NSMutableArray *dataArray;

@end

NS_ASSUME_NONNULL_END
