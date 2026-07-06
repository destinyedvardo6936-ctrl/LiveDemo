//
//  LCUserLevelModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/24.
//

#import "LCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCUserLevelModel : LCBaseModel
@property (nonatomic , copy) NSString              * levelid;
@property (nonatomic , copy) NSString              * thumb;
@property (nonatomic , copy) NSString              * colour;
@property (nonatomic , copy) NSString              * thumb_mark;
@property (nonatomic , copy) NSString              * bg;
@end

NS_ASSUME_NONNULL_END
