//
//  LCLiveGiftSelectView.h
//  LiveDemo
//
//  Created by mrgao on 2023/3/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCLiveGiftSelectView : UIView
- (instancetype)initWithFrame:(CGRect)frame contentOrigin:(CGPoint)contentOrigin titles:(NSArray *)titles;
@property (nonatomic , copy) void (^dismissBlock)(void);
@property (nonatomic , copy) void(^selectBlock)(NSString *selectTitle);
@end

NS_ASSUME_NONNULL_END
