//
//  LCAccountDetailsViewModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/6/8.
//

#import "LCBaseViewModel.h"
#import "LCAccountDetailsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCAccountDetailsViewModel : LCBaseViewModel
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , strong) LCBaseListApi *listApi;
@end

NS_ASSUME_NONNULL_END
