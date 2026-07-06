//
//  LCMessageListViewModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/22.
//

#import "LCBaseViewModel.h"
#import "LCMessageListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCMessageListViewModel : LCBaseViewModel
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , strong) LCBaseListApi *listApi;
@end

NS_ASSUME_NONNULL_END
