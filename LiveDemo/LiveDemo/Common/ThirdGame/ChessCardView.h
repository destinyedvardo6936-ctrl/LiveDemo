//
//  ChessCardView.h
//  yunbaolive
//
//  Created by 陶成堂 on 2020/5/9.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChessCardView : UIView
@property (weak, nonatomic) IBOutlet UILabel *thirdTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstTipLabel;
- (instancetype)init;
@property (nonatomic,strong)IBOutlet UIView *btmView;
@property (nonatomic,strong)IBOutlet UIButton *cancelBtn;
@property (nonatomic,strong)IBOutlet UIButton *sureBtn;
@property (nonatomic,strong)IBOutlet UILabel *banLab;

@end

NS_ASSUME_NONNULL_END
