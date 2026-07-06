//
//  LCWithDrawViewModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/21.
//

#import "LCBaseViewModel.h"
#import "LCWithDrawPaymentModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCWithDrawPaymentViewModel : LCBaseViewModel
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , strong) NSMutableArray *noticeArray;//公告
@property (nonatomic , strong) RACCommand *noticeCommand;
@property (nonatomic , strong) RACSubject *noticeSubject;
@end

NS_ASSUME_NONNULL_END
