//
//  LCBlackShelterView.m
//  liveCommon
//
//  Created by mrgao on 2022/10/2.
//

#import "LCBlackShelterView.h"

@implementation LCBlackShelterView
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
