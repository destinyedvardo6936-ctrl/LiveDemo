//
//  LCHomeBannerCollectionCell.h
//  LiveDemo
//
//  Created by mrgao on 2022/11/21.
//

#import "LCBaseCollectionViewCell.h"
#import "LCBannerModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCHomeBannerCollectionCell : LCBaseCollectionViewCell
@property (nonatomic , copy) NSArray *dataArray;
@property (nonatomic , copy) void(^clickBlock)(NSInteger index);
@end

NS_ASSUME_NONNULL_END
