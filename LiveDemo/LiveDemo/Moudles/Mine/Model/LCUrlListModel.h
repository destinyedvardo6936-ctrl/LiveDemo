//
//  LCUrlListModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/24.
//

#import "LCBaseModel.h"
#import "LCMineUrlModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCUrlListModel : LCBaseModel
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSArray<LCMineUrlModel *>              * list;
@end

NS_ASSUME_NONNULL_END
