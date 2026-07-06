//
//  LCVideoListViewModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/5/6.
//

#import "LCBaseViewModel.h"
#import "LCVideoListModel.h"
#import "LCBannerModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCVideoListViewModel : LCBaseViewModel
@property (nonatomic , copy) NSString *channelId;
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , strong) LCBaseListApi *listApi;

@property (nonatomic , strong) NSMutableArray *bannerArray;
@property (nonatomic , strong) RACCommand *bannerCommand;
@property (nonatomic , strong) RACSubject *bannerSubject;
@end

NS_ASSUME_NONNULL_END
