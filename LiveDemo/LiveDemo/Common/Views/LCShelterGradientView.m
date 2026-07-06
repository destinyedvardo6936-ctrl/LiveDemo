//
//  LCShelterGradientView.m
//  LCHeadlines
//
//  Created by mrgao on 2020/6/6.
//  Copyright © 2020 WY. All rights reserved.
//

#import "LCShelterGradientView.h"

@implementation LCShelterGradientView
+ (Class)layerClass {
    return [CAGradientLayer class];
}

- (CAGradientLayer *)gradientLayer {
    return (CAGradientLayer *)self.layer;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
