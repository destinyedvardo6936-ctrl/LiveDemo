//
//  LCLotteryTicketConfimView.h
//  LiveDemo
//
//  Created by mrgao on 2023/3/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCLotteryTicketConfimView : UIView
@property (nonatomic , copy) NSString *zhuboId;
@property (nonatomic , copy) NSString *selectedBeishu;

@property (nonatomic , strong) NSMutableArray *wanfaSelectArr;
@property (nonatomic , copy) void (^dismissBlock)(void);
@property (nonatomic , copy) void (^sendBlock)(NSDictionary *dic);
@end

NS_ASSUME_NONNULL_END
