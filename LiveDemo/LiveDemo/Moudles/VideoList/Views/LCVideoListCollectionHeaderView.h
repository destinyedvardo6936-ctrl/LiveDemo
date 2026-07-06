//
//  LCVideoListCollectionHeaderView.h
//  LiveDemo
//
//  Created by mrgao on 2023/5/7.
//

#import <UIKit/UIKit.h>
#import "LCBannerModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCVideoListCollectionHeaderView : UICollectionReusableView
@property (nonatomic , strong)NSArray *dataArray;
@property (nonatomic , copy)void (^clickBlock)(LCBannerModel *selectModel);
@end

NS_ASSUME_NONNULL_END
