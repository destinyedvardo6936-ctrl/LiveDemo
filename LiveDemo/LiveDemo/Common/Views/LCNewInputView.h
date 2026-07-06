//
//  LCNewInputView.h
//  LCHeadlines
//
//  Created by mrgao on 2020/10/12.
//  Copyright © 2020 WY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCNewInputView : UIView
@property (nonatomic,copy)void(^sendBlock)(NSString *text);
@property (nonatomic,copy)NSString *placeHolderText;
- (void)showKeyBoard;
@end

NS_ASSUME_NONNULL_END
