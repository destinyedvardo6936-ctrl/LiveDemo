//
//  LCLoadingView.m
//  LCHeadlines
//
//  Created by mrgao on 2019/12/9.
//  Copyright © 2019 WY. All rights reserved.
//

#import "LCLoadingView.h"
#import <FBShimmeringView.h>

@interface LCLoadingView ()
@property (nonatomic,weak)FBShimmeringView *loadingView;
@end
@implementation LCLoadingView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = Color(@"#F6F6F6");
        [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
    }
    return self;
}
- (void)setCustomTop:(CGFloat)customTop{
    _customTop = customTop;
    self.loadingView.shimmering = NO;
     UIView *contentView = [[UIView alloc]initWithFrame:self.bounds];
            
            UIImageView *imageView = [[UIImageView alloc]initWithImage:image(@"logo")];
            imageView.frame = CGRectMake((self.width - kUI_Width(90))/2.0, (self.height - kUI_Width(90))/2.0 - _customTop, kUI_Width(90), kUI_Width(90));
            CGAffineTransform matrix = CGAffineTransformMakeRotation(-M_PI / 180 * 20);
                    imageView.transform = matrix;
            [contentView addSubview:imageView];
            imageView.tag = 200;
    
            self.loadingView.contentView = contentView;
    self.loadingView.shimmering = YES;

}

#pragma mark----懒加载----
- (FBShimmeringView *)loadingView{
    if (_loadingView == nil) {
        FBShimmeringView *view  = [[FBShimmeringView alloc] initWithFrame:CGRectZero];
        _loadingView = view;
        _loadingView.shimmering = YES;
        _loadingView.shimmeringBeginFadeDuration = 0.5;
        _loadingView.shimmeringOpacity = 0.1;
//        _loadingView.shimmeringSpeed = 200;
//        UILabel *logoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.height - 400)/2.0, self.width, 400)];
//        logoLabel.text = @"来电APP";
//        logoLabel.font = MediumFont(60);
//        logoLabel.textColor = Color(@"#000000);
//        logoLabel.textAlignment = NSTextAlignmentCenter;
//        logoLabel.backgroundColor = [UIColor clearColor];
//
////        CGAffineTransform matrix = CGAffineTransformMakeRotation(-M_PI / 180 * 20);
////        logoLabel.transform = matrix;
//        _loadingView.contentView = logoLabel;
        UIView *contentView = [[UIView alloc]initWithFrame:self.bounds];
        contentView.backgroundColor =Color(@"#F6F6F6");
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((self.width - kUI_Width(100))/2.0, (self.height - kUI_Width(100))/2.0-kUI_Width(20), kUI_Width(100), kUI_Width(100))];
        label.text = @"助农商城";
        label.font = BoldFont(24);
        label.tag = 200;
        label.textColor = Color(@"#0FC792");
        CGAffineTransform matrix = CGAffineTransformMakeRotation(-M_PI / 180 * 20);
        label.transform = matrix;
        [contentView addSubview:label];
//        UIImageView *imageView = [[UIImageView alloc]initWithImage:image(@"logo")];
//        imageView.frame = CGRectMake((self.width - kUI_Width(90))/2.0, (self.height - kUI_Width(90))/2.0 - kUI_Width(20), kUI_Width(90), kUI_Width(90));
//        CGAffineTransform matrix = CGAffineTransformMakeRotation(-M_PI / 180 * 20);
//                imageView.transform = matrix;
//        [contentView addSubview:imageView];
//        imageView.tag = 200;
//        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(0);
//            make.centerY.equalTo(0);
//            make.width.height.equalTo(kUI_Width(80));
//        }];
        _loadingView.contentView = contentView;
        [self addSubview:_loadingView];
    }
    return _loadingView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
