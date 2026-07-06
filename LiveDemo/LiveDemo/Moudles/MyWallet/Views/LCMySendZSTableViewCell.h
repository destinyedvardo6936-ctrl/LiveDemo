//
//  LCMySendZSTableViewCell.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/17.
//

#import "LCBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCMySendZSTableViewCell : LCBaseTableViewCell
@property (nonatomic , copy) NSString *sendZSStr;
@property (nonatomic , strong) RACSubject *btnClickSubject;
@end

NS_ASSUME_NONNULL_END
