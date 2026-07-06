//
//  LCNoDataView.h
//  LCHeadlines
//
//  Created by mrgao on 2019/12/10.
//  Copyright © 2019 WY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCNoDataView : UIView
@property (nonatomic,copy)NSString *title;
@property (nonatomic,assign)CGRect customTitleFrame;
@property (nonatomic , strong) UIImage *customImg;
@property (nonatomic,assign)CGRect customImageFrame;
@property (nonatomic , strong) UIColor *customBgColor;
@property (nonatomic , assign) BOOL needImgHidden;
@end

NS_ASSUME_NONNULL_END
