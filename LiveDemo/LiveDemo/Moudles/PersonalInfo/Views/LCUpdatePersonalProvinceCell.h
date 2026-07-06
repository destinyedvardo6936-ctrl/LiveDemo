//
//  LCUpdatePersonalProvinceCell.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/23.
//

#import "LCBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCUpdatePersonalProvinceCell : LCBaseTableViewCell
@property (nonatomic , copy) NSString *province;
@property (nonatomic , copy) void (^textChangeBlock)(NSString *text);
@end

NS_ASSUME_NONNULL_END
