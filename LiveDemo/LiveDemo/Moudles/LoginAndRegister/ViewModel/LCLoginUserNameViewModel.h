//
//  LCLoginUserNameViewModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/5/7.
//

#import "LCBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCLoginUserNameViewModel : LCBaseViewModel
@property (nonatomic , copy) NSString *account;
@property (nonatomic , copy) NSString *passward;
@property (nonatomic , copy) NSString *country_code;
@end

NS_ASSUME_NONNULL_END
