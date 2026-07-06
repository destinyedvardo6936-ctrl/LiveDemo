//
//  LCVideoDetailViewModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/5/9.
//

#import "LCBaseViewModel.h"
#import "LCVideoListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCVideoDetailViewModel : LCBaseViewModel
@property (nonatomic,strong)LCVideoListModel *currentVideoModel;
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , strong) LCBaseListApi *listApi;
@end

NS_ASSUME_NONNULL_END
