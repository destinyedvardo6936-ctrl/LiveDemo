//
//  LCAudienceCollectionViewCell.h
//  LiveDemo
//
//  Created by mrgao on 2022/11/27.
//

#import "LCBaseCollectionViewCell.h"
#import "LCLiveUserModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCAudienceCollectionViewCell : LCBaseCollectionViewCell
@property (nonatomic , strong) LCLiveUserModel *dataModel;
@end

NS_ASSUME_NONNULL_END
