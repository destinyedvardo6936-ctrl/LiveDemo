//
//  LCMineUrlModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/24.
//

#import "LCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCMineUrlModel : LCBaseModel
@property (nonatomic , copy) NSString              * modelId;
@property (nonatomic , copy) NSString              * thumb;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * href;
@end

NS_ASSUME_NONNULL_END
