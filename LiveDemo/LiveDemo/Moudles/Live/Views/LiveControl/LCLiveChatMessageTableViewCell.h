//
//  LCLiveChatMessageTableViewCell.h
//  LiveDemo
//
//  Created by mrgao on 2023/3/7.
//

#import "LCBaseTableViewCell.h"
#import "LCChatMessageModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCLiveChatMessageTableViewCell : LCBaseTableViewCell
@property (nonatomic , strong) LCChatMessageModel *dataModel;
@end

NS_ASSUME_NONNULL_END
