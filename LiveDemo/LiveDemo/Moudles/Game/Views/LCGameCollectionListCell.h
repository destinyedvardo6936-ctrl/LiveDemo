//
//  LCGameCollectionListCell.h
//  LiveDemo
//
//  Created by mrgao on 2023/3/17.
//

#import "LCBaseCollectionViewCell.h"
#import "LCGameListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCGameCollectionListCell : LCBaseCollectionViewCell
@property (nonatomic , strong) LCGameListModel *dataModel;
@end

NS_ASSUME_NONNULL_END
