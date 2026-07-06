//
//  LCMineFunTableViewCell.h
//  LiveDemo
//
//  Created by mrgao on 2023/1/6.
//

#import "LCBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCMineFunTableViewCell : LCBaseTableViewCell
@property (nonatomic , strong) RACSubject *btnClickSubject;
@end

NS_ASSUME_NONNULL_END
