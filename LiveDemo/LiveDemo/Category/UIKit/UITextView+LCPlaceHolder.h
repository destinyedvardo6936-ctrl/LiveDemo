//
//  UITextView+LCPlaceHolder.h
//  LDHeadlines
//
//  Created by mrgao on 2019/11/28.
//  Copyright © 2019 personal. All rights reserved.
//




#import <UIKit/UIKit.h>
FOUNDATION_EXPORT double UITextView_PlaceholderVersionNumber;
FOUNDATION_EXPORT const unsigned char UITextView_PlaceholderVersionString[];

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (LDPlaceHolder)
@property(nonatomic, readonly) UILabel *placeholderLabel;

@property(nonatomic, strong) IBInspectable NSString
*
placeholder;
@property(nonatomic, strong) NSAttributedString *attributedPlaceholder;
@property(nonatomic, strong) IBInspectable UIColor
*
placeholderColor;
@property(nonatomic, strong) IBInspectable UIFont
*
placeFont;
@end

NS_ASSUME_NONNULL_END
