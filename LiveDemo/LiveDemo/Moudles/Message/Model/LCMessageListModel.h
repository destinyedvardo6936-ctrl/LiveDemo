//
//  LCMessageListModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/22.
//

#import "LCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCMessageListModel : LCBaseModel
@property (nonatomic , copy) NSString              * content;
//@property (nonatomic , copy) NSString              * type;
//@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * addtime;
@end

NS_ASSUME_NONNULL_END
