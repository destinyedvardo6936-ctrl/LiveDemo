//
//  LCUpdatePersonalSexCell.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/18.
//

#import "LCBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCUpdatePersonalSexCell : LCBaseTableViewCell
@property (nonatomic , copy) NSString *sex;
@property (nonatomic , strong) RACSubject *btnClickSubject;
@end

NS_ASSUME_NONNULL_END
