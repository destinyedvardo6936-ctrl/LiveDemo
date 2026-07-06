//
//  LCBettingRecordViewModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/5/9.
//

#import "LCBaseViewModel.h"
#import "LCBettingRecordModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCTotalBettingRecordViewModel : LCBaseViewModel
@property (nonatomic , assign) BOOL isBc;
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , strong) LCBaseListApi *listApi;
@end

NS_ASSUME_NONNULL_END
