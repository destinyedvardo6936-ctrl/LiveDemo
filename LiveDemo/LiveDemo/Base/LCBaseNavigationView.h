//
//  LCBaseNavigationView.h
//  liveCommon
//
//  Created by mrgao on 2022/9/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    LCBaseNavigationViewLeftType_None,
    LCBaseNavigationViewLeftType_BlackBack,
    LCBaseNavigationViewLeftType_WhiteBack,
    LCBaseNavigationViewLeftType_Text,
    LCBaseNavigationViewLeftType_Image,
} LCBaseNavigationViewLeftType;
typedef enum : NSUInteger {
    LCBaseNavigationViewRightType_None,
    LCBaseNavigationViewRightType_Text,
    LCBaseNavigationViewRightType_Image,
} LCBaseNavigationViewRightType;

@protocol LCBaseNavigationViewDelegate <NSObject>

- (void)leftButtonClicked;
- (void)rightButtonClicked;

@end
@interface LCBaseNavigationView : UIView
@property (nonatomic,assign)id<LCBaseNavigationViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame
                        title:(NSString *)title
                     leftType:(LCBaseNavigationViewLeftType)leftType  rightType:(LCBaseNavigationViewRightType)rightType;
- (void)setBottomBackgroundColor:(UIColor *)color;

- (void)setLeftButtonType:(LCBaseNavigationViewLeftType)type;
- (void)setRightButtonType:(LCBaseNavigationViewRightType)type;

- (void)setCustomLeftTitle:(NSString *)leftTitle;
- (void)setCustomRightTitle:(NSString *)rightTitle;

- (void)setCustomLeftTextColor:(UIColor *)color;
- (void)setCustomRightTextColor:(UIColor *)color;

- (void)setCustomLeftTextFont:(UIFont *)font;
- (void)setCustomRightTextFont:(UIFont *)font;

- (void)setCenterLabelText:(NSString *)title;
- (void)setCenterLabelTextColor:(UIColor *)color;
- (void)setCenterLabelFont:(UIFont *)font;

- (void)setCustomLeftImageStr:(NSString *)leftImgStr;
- (void)setCustomRightImageStr:(NSString *)leftImgStr;


- (NSString *)centerTitle;
@end

NS_ASSUME_NONNULL_END
