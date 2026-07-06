//
//  LCLiveLotteryTicketWanfaView.h
//  LiveDemo
//
//  Created by mrgao on 2023/3/23.
//

#import <UIKit/UIKit.h>
#import <JXPagingView/JXPagerView.h>
NS_ASSUME_NONNULL_BEGIN

@interface LCLiveLotteryTicketWanfaView : UIView<JXPagerViewListViewDelegate>
@property (nonatomic , strong) NSMutableArray *dataArray;
@end

NS_ASSUME_NONNULL_END
