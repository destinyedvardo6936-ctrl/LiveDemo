//
//  LCHomeOtherLiveListViewModel.h
//  LiveDemo
//
//  Created by mrgao on 2022/12/31.
//

#import "LCBaseViewModel.h"
#import "LCHomeListModel.h"
#import "LCBannerModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCHomeOtherLiveListViewModel : LCBaseViewModel

@property (nonatomic , strong ) NSMutableArray *bannerArray;
@property (nonatomic , strong ) NSMutableArray *dataArray;
@property (nonatomic , copy) NSString *currentFirstChannel;
@property (nonatomic , copy) NSString *channelId;
@property (nonatomic , strong) LCBaseListApi *listApi;
@end

NS_ASSUME_NONNULL_END
