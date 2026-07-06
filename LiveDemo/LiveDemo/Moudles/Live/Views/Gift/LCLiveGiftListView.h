//
//  LCLiveGiftListView.h
//  LiveDemo
//
//  Created by mrgao on 2023/3/13.
//

#import <UIKit/UIKit.h>
#import "LCLiveRoomGiftListViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCLiveGiftListView : UIView
@property (nonatomic , copy) NSString *roomId;
@property (nonatomic , copy) NSString *stream;

@property (nonatomic , copy) void (^dismissBlock)(void);
@property (nonatomic , copy) void (^rechageClickBlock)(void);
@property (nonatomic , copy) void (^sendClickBlock)(NSString *giftToken,NSString * nums);
@end

NS_ASSUME_NONNULL_END
