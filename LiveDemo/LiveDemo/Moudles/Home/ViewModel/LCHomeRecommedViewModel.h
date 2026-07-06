//
//  LCHomeRecommedViewModel.h
//  liveCommon
//
//  Created by mrgao on 2022/9/30.
//

#import "LCBaseViewModel.h"
#import "LCHomeListModel.h"
#import "LCBannerModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCHomeRecommedViewModel : LCBaseViewModel
//@property (nonatomic , strong ) NSMutableArray *dataArray;

@property (nonatomic , strong ) NSMutableArray *topDataArray;
@property (nonatomic , strong ) NSMutableArray *bottomDataArray;
@property (nonatomic , strong ) NSMutableArray *bannerArray;
@property (nonatomic , strong ) NSMutableArray *recommendArchorArray;
@property (nonatomic , strong ) NSMutableArray *gameRecommendArchorArray;


@property (nonatomic , strong) LCBaseListApi *listApi;


@end

NS_ASSUME_NONNULL_END
