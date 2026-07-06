//
//  LCUserHomeTableViewCell.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/22.
//

#import "LCBaseTableViewCell.h"
#import "LCUserHomeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCUserHomeTableViewCell : LCBaseTableViewCell
@property (nonatomic , strong) LCUserHomeModel *dataModel;
@property (nonatomic , strong) RACSubject *followClickSubject;
@property (nonatomic , strong) RACSubject *fansClickSubject;
@property (nonatomic , strong) RACSubject *contributeClickSubject;
//@property (nonatomic , strong) RACSubject *jumpToLiveSubject;
@end

NS_ASSUME_NONNULL_END
