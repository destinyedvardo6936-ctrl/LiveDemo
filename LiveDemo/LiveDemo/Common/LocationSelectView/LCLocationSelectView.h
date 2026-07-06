//
//  LCLocationSelectView.h
//  LiveDemo
//
//  Created by mrgao on 2022/11/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCLocationSelectView : UIView
@property (nonatomic , copy) NSString *currentArea;
@property (nonatomic , copy)void(^selectBlock)(NSString *area);
@end

NS_ASSUME_NONNULL_END
