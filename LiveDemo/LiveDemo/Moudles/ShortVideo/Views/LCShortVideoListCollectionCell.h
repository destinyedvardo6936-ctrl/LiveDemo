//
//  LCShortVideoListCollectionCell.h
//  LiveDemo
//
//  Created by mrgao on 2023/5/8.
//

#import "LCBaseCollectionViewCell.h"
#import "LCShortVideoListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCShortVideoListCollectionCell : LCBaseCollectionViewCell
@property (nonatomic , strong) LCShortVideoListModel *dataModel;
@end

NS_ASSUME_NONNULL_END
