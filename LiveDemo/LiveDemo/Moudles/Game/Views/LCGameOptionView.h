//
//  LCGameOptionView.h
//  LiveDemo
//
//  Created by mrgao on 2023/3/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCGameOptionView : UIView
@property (nonatomic , copy) void (^btnClickBlock)(NSInteger index);
@end

NS_ASSUME_NONNULL_END
