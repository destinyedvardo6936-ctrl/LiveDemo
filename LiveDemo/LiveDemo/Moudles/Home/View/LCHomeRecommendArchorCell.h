//
//  LCHomeRecommendArchorCell.h
//  LiveDemo
//
//  Created by mrgao on 2022/11/21.
//

#import "LCBaseCollectionViewCell.h"
#import "LCHomeListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCHomeRecommendArchorCell : LCBaseCollectionViewCell
@property (nonatomic , copy) NSArray *dataArray;
@property (nonatomic , copy) NSString *titleStr;
@property (nonatomic , copy) void(^clickBlock)(LCHomeListModel *selectModel);
@end

NS_ASSUME_NONNULL_END
