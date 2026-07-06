//
//  LCLiveGamesSelectView.h
//  LiveDemo
//
//  Created by mrgao on 2022/12/3.
//

#import <UIKit/UIKit.h>
#import "LCLiveGameTypeViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCLiveGamesSelectView : UIView
@property (nonatomic , assign) BOOL isFromVideo;
@property (nonatomic , copy) void (^dismissBlock)(void);
@property (nonatomic , copy) void (^rechageClickBlock)(void);
@property (nonatomic , copy) void (^gameCenterClickBlock)(void);
@end

NS_ASSUME_NONNULL_END
