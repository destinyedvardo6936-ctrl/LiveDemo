//
//  LCVideoListCollectionViewCell.h
//  LiveDemo
//
//  Created by mrgao on 2023/5/7.
//

#import "LCBaseCollectionViewCell.h"
#import "LCVideoListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCVideoListCollectionViewCell : LCBaseCollectionViewCell
@property (nonatomic , strong) LCVideoListModel *dataModel;
@end

NS_ASSUME_NONNULL_END
