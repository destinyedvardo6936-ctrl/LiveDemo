//
//  LCUserContributeCollectionViewCell.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/22.
//

#import "LCBaseCollectionViewCell.h"
#import "LCUserContributeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCUserContributeCollectionViewCell : LCBaseCollectionViewCell
@property (nonatomic , strong) LCUserContributeModel *dataModel;
@end

NS_ASSUME_NONNULL_END
