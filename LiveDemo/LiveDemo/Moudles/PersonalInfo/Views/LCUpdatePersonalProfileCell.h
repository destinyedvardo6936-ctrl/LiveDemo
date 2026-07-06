//
//  LCUpdatePersonalProfileCell.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/18.
//

#import "LCBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCUpdatePersonalProfileCell : LCBaseTableViewCell
@property (nonatomic , copy) NSString *profile;
@property (nonatomic , copy) void (^textChangeBlock)(NSString *text,CGFloat height);
@end

NS_ASSUME_NONNULL_END
