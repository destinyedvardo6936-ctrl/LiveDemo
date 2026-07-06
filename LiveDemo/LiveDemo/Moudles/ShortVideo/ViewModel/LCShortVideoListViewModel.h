//
//  LCShortVideoListViewModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/5/8.
//

#import "LCBaseViewModel.h"
#import "LCShortVideoListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCShortVideoListViewModel : LCBaseViewModel
@property (nonatomic , strong ) NSMutableArray *dataArray;

@property (nonatomic , copy) NSString *channelId;
@property (nonatomic , strong) LCBaseListApi *listApi;
@end

NS_ASSUME_NONNULL_END
