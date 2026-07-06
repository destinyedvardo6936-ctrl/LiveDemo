//
//  LCUpdatePersonalNicknameCell.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/18.
//

#import "LCBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCUpdatePersonalNicknameCell : LCBaseTableViewCell
@property (nonatomic , copy) NSString *nickName;
@property (nonatomic , copy) void (^textChangeBlock)(NSString *text);
@end

NS_ASSUME_NONNULL_END
