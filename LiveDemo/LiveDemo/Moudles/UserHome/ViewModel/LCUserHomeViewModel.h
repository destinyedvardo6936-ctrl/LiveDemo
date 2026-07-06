//
//  LCUserHomeViewModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/22.
//

#import "LCBaseViewModel.h"
#import "LCUserHomeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCUserHomeViewModel : LCBaseViewModel
@property (nonatomic , copy) NSString *userId;
@property (nonatomic , strong) LCUserHomeModel *dataModel;
@property (nonatomic , strong) RACCommand *followCommand;
@property (nonatomic , strong) RACSubject *followSubject;


@end

NS_ASSUME_NONNULL_END
