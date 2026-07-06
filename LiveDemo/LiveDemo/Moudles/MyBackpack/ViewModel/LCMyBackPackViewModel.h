//
//  LCMyBackPackViewModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/15.
//

#import "LCBaseViewModel.h"
#import "LCMyBackPackModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCMyBackPackViewModel : LCBaseViewModel
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , strong) LCBaseListApi *listApi;
@end

NS_ASSUME_NONNULL_END
