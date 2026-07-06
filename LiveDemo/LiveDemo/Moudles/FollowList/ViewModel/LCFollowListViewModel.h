//
//  LCFollowListViewModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/22.
//

#import "LCBaseViewModel.h"
#import "LCRankArchorModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCFollowListViewModel : LCBaseViewModel

@property (nonatomic , copy) NSString *userId;
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , strong) LCBaseListApi *listApi;
@property (nonatomic , strong) RACCommand *followCommand;
@property (nonatomic , strong) RACSubject *followSubject;
@end

NS_ASSUME_NONNULL_END
