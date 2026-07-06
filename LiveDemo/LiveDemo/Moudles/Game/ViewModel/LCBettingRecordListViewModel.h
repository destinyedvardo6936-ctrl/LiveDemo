//
//  LCBettingRecordListViewModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/3/17.
//

#import "LCBaseViewModel.h"
#import "LCBettingRecordModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCBettingRecordListViewModel : LCBaseViewModel
@property (nonatomic , copy) NSString *biaoshi;
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , strong) LCBaseListApi *listApi;
@end

NS_ASSUME_NONNULL_END
