//
//  LCMineBannerTableViewCell.h
//  LiveDemo
//
//  Created by mrgao on 2023/1/7.
//

#import "LCBaseTableViewCell.h"
#import "LCBannerModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCMineBannerTableViewCell : LCBaseTableViewCell
@property (nonatomic , copy) NSArray *dataArray;
@property (nonatomic , copy) void(^clickBlock)(NSInteger index);
@end

NS_ASSUME_NONNULL_END
