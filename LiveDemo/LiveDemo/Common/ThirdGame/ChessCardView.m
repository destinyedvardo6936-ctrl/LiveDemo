//
//  ChessCardView.m
//  yunbaolive
//
//  Created by 陶成堂 on 2020/5/9.
//  Copyright © 2020 cat. All rights reserved.
//

#import "ChessCardView.h"

@implementation ChessCardView

- (instancetype)init
{
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"ChessCardView" owner:self options:nil] firstObject];
        self.size =CGSizeMake(SCREEN_WIDTH,SCREEN_HEIGHT);
        _btmView.layer.masksToBounds=YES;
        _btmView.layer.cornerRadius=10.0;
        _thirdTipLabel.text = KLanguage(@"当前游戏可用额度为");
        _firstTipLabel.text = KLanguage(@"是否需要转入额度？");
    }
  
    
    return self;
}

@end
