//
//  LCLiveLotteryTicketDetailView.h
//  LiveDemo
//
//  Created by mrgao on 2023/3/22.
//

#import <UIKit/UIKit.h>
#import "LCGameListModel.h"
#import "LCLotteryTicketPlayViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCLiveLotteryTicketDetailView : UIView
@property (nonatomic , assign) BOOL isFromVideo;
@property (nonatomic , strong) LCGameListModel *dataModel;
@property (nonatomic , copy) void (^dismissBlock)(void);
@property (nonatomic , copy) void (^backBlock)(void);
@property (nonatomic , copy) void (^submitClickBlock)(NSMutableArray *array);
@property (nonatomic , copy) void (^btnClickBlock)(NSInteger index,LCGameListModel *model);
@property (nonatomic , copy) void (^rechageClickBlock)(void);
@end

NS_ASSUME_NONNULL_END
