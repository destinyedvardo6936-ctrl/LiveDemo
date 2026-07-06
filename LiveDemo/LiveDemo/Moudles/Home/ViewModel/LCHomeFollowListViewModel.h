//
//  LCHomeFollowListViewModel.h
//  LiveDemo
//
//  Created by mrgao on 2022/11/23.
//

#import "LCBaseViewModel.h"
#import "LCHomeListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCHomeFollowListViewModel : LCBaseViewModel
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , strong) NSMutableArray *recommendArray;
@property (nonatomic , strong) RACCommand *replaceRecommendCommand;
@property (nonatomic , strong) RACSubject *replaceRecommendSubject;
@property (nonatomic , strong) LCBaseListApi *listApi;
@end

NS_ASSUME_NONNULL_END
