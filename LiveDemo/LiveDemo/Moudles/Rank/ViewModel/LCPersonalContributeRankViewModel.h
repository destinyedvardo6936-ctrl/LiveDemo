//
//  LCPersonalContributeRankViewModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/23.
//

#import "LCBaseViewModel.h"
#import "LCRankArchorModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCPersonalContributeRankViewModel : LCBaseViewModel
@property (nonatomic , copy) NSString *userId;
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , strong) LCBaseListApi *listApi;
@property (nonatomic , strong) RACCommand *followCommand;
@property (nonatomic , strong) RACSubject *followSubject;
@end

NS_ASSUME_NONNULL_END
