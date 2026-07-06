//
//  LCLiveListCollectionViewCell.h
//  liveCommon
//
//  Created by mrgao on 2022/9/30.
//

#import "LCBaseCollectionViewCell.h"
#import "LCHomeListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCLiveListCollectionViewCell : LCBaseCollectionViewCell
@property (nonatomic , strong) LCHomeListModel *dataModel;
@end

NS_ASSUME_NONNULL_END
