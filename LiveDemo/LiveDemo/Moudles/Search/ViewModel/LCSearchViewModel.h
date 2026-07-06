//
//  LCSearchViewModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/2.
//

#import "LCBaseViewModel.h"
#import "LCRankArchorModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCSearchViewModel : LCBaseViewModel
@property (nonatomic , copy) NSString *searchText;
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , strong) LCBaseListApi *listApi;
@end

NS_ASSUME_NONNULL_END
