//
//  BuyVip.m
//  yunbaolive
//
//  Created by 陶成堂 on 2020/8/4.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BuyVip.h"

@implementation BuyVip
- (instancetype)init
{
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"BuyVip" owner:self options:nil] firstObject];
        self.size =CGSizeMake(SCREEN_WIDTH,SCREEN_HEIGHT);
    }
//    self.btn1.layer.masksToBounds = YES;
//    self.btn1.layer.cornerRadius = 14.0;
//    
//    CALayer *layer = [self.btn1 layer];
//    layer.borderColor=[UIColor blueColor].CGColor;
//    layer.borderWidth=1;
    self.messagLab.text = KLanguage(@"非VIP会员不能观看，请升级VIP");
    [self.btn1 setTitle:KLanguage(@"取消观看") forState:UIControlStateNormal];
    [self.btn3 setTitle:KLanguage(@"升级VIP") forState:UIControlStateNormal];
    self.btn3.layer.masksToBounds=YES;
    self.btn3.layer.cornerRadius=14.0;
    
    self.btmView.layer.masksToBounds=YES;
    self.btmView.layer.cornerRadius=15.0;
    
    //    self.btn3.titleLabel.textAlignment=NSTextAlignmentCenter;
    //    [self.btn3 setTitle:@"去分享" forState:UIControlStateNormal];
    //    self.btn3.titleLabel.lineBreakMode = 0;//这句话很重要，不加这句话加上换行符也没用
    
    return self;
}





@end
