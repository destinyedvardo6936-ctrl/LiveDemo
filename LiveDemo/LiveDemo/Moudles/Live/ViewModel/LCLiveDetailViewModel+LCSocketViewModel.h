//
//  LCLiveDetailViewModel+LCSocketViewModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/3/6.
//

#import "LCLiveDetailViewModel.h"
#import "LCSocketManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCLiveDetailViewModel (LCSocketViewModel)<LCSocketManagerDelegate>

- (void)connectToSocket;
- (void)disconnetSocket;

- (void)sendDanMuWithText:(NSString *)text;
- (void)sendMessageWithText:(NSString *)text;
- (void)sendGiftWithModel:(NSString *)giftToken num:(NSInteger)num;
- (void)sendLotteryTicketMessage:(NSDictionary *)dic;
- (void)sendBuyGuardMessage:(NSDictionary *)dic;
- (void)sendStartPlayLotteryTicketWithBiaoshi:(NSString *)biaoshi;
- (void)sendEndPlayLotteryTicketWithBiaoshi:(NSString *)biaoshi;
- (void)sendCheckResultLotteryTicketWithBiaoshi:(NSString *)biaoshi;
@end

NS_ASSUME_NONNULL_END
