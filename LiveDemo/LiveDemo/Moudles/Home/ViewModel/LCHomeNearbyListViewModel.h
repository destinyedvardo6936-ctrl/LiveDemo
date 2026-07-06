//
//  LCHomeNearbyListViewModel.h
//  LiveDemo
//
//  Created by mrgao on 2022/11/23.
//

#import "LCBaseViewModel.h"
#import "LCHomeListModel.h"
#import "LCBannerModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCHomeNearbyListViewModel : LCBaseViewModel
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , copy) NSString *area;
@property (nonatomic , copy) NSString *sex;
@property (nonatomic , strong ) NSMutableArray *bannerArray;

@property (nonatomic , strong) LCBaseListApi *listApi;
@end

NS_ASSUME_NONNULL_END
