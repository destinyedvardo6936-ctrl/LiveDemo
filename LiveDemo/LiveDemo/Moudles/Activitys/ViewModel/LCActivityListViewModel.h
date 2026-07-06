//
//  LCActivityListViewModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/1/3.
//

#import "LCBaseViewModel.h"
#import "LCActivityTypeModel.h"
#import "LCActivityModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCActivityListViewModel : LCBaseViewModel
@property (nonatomic , strong) LCActivityTypeModel *dataModel;
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , strong) LCBaseListApi *listApi;
@end

NS_ASSUME_NONNULL_END
