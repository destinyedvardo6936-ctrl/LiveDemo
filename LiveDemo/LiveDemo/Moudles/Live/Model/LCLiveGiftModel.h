//
//  LCLiveGiftModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/3/13.
//

#import "LCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCLiveGiftModel : LCBaseModel
@property (nonatomic , copy) NSString              * needcoin;
@property (nonatomic , copy) NSString              * gifticon;
@property (nonatomic , copy) NSString              * sticker_id;
@property (nonatomic , copy) NSString              * modelId;
@property (nonatomic , copy) NSString              * mark;
@property (nonatomic , copy) NSString              * swftime;
@property (nonatomic , copy) NSString              * isplatgift;
@property (nonatomic , copy) NSString              * nums;
@property (nonatomic , copy) NSString              * type;
@property (nonatomic , copy) NSString              * giftname;

@property (nonatomic , assign) BOOL isSelected;
@end

NS_ASSUME_NONNULL_END
