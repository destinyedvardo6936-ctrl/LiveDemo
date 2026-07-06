//
//  LCHomeWebAlertView.h
//  LiveDemo
//
//  Created by mrgao on 2024/7/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCHomeWebAlertView : UIView
@property (nonatomic , copy) NSString *webText;
@property (nonatomic,copy)void (^closeBlock)(void);
@end

NS_ASSUME_NONNULL_END
