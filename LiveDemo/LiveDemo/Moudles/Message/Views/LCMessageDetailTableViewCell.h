//
//  LCMessageDetailTableViewCell.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/22.
//

#import "LCBaseTableViewCell.h"
#import "LCMessageListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCMessageDetailTableViewCell : LCBaseTableViewCell
@property (nonatomic , strong) LCMessageListModel *dataModel;
@end

NS_ASSUME_NONNULL_END
