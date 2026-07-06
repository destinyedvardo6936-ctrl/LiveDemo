//
//  LCSearchApi.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/2.
//

#import "LCBaseListApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCSearchApi : LCBaseListApi
@property (nonatomic , copy) NSString *searchText;
@end

NS_ASSUME_NONNULL_END
