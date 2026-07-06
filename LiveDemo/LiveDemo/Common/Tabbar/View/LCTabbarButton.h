//
//  LDTabbarButton.h
//  LDHeadlines
//
//  Created by mrgao on 2019/12/4.
//  Copyright © 2019 personal. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCTabbarButton : UIView
@property (nonatomic,assign,readonly)BOOL isAnimation;
@property (nonatomic,assign,readonly)BOOL isSelected;

@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)void(^tabSelectedBlock)(LCTabbarButton *selectedView);
@property (nonatomic,copy)void(^refreshBlock)(void);


- (instancetype)initWithFrame:(CGRect)frame
normalImage:(UIImage *)normalImg
      selectImage:(UIImage *)selectImage
                        title:(NSString *)title imageSize:(CGSize)imageSize;
- (void)makeImgViewSelected:(BOOL)isSelected;
- (void)makeImgViewSelected:(BOOL)isSelected animated:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
