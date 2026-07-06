//
//  LCNoDataView.m
//  LCHeadlines
//
//  Created by mrgao on 2019/12/10.
//  Copyright © 2019 WY. All rights reserved.
//

#import "LCNoDataView.h"

@interface LCNoDataView ()
@property (nonatomic,weak)UIImageView *mainImgView;
@property (nonatomic,weak)UILabel *mainLabel;
@end
@implementation LCNoDataView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = Color(@"#F5F8FC");
        [self.mainImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.width.height.equalTo(kUI_Width(108));
            make.centerY.equalTo(-kUI_Width(13));
        }];
        [self.mainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.top.mas_equalTo(self.mainImgView.mas_bottom).offset(kUI_Width(6));
        }];
    }
    return self;
}
- (void)setTitle:(NSString *)title{
    _title = [title copy];
    self.mainLabel.text = _title;
}
- (void)setCustomTitleFrame:(CGRect)customTitleFrame{
    _customTitleFrame = customTitleFrame;
    [self.mainLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_customTitleFrame.origin.y);
        make.left.equalTo(_customTitleFrame.origin.x);
        make.width.equalTo(_customTitleFrame.size.width);
        make.height.equalTo(_customTitleFrame.size.height);
    }];
}
- (void)setCustomImageFrame:(CGRect)customImageFrame{
    _customImageFrame = customImageFrame;
    [self.mainImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_customImageFrame.origin.y);
        make.left.equalTo(_customImageFrame.origin.x);
        make.width.equalTo(_customImageFrame.size.width);
        make.height.equalTo(_customImageFrame.size.height);
    }];
}
- (void)setCustomBgColor:(UIColor *)customBgColor{
    _customBgColor = customBgColor;
    self.backgroundColor = _customBgColor;
}
- (void)setCustomImg:(UIImage *)customImg{
    _customImg = customImg;
    self.mainImgView.image = customImg;
    
}
- (void)setNeedImgHidden:(BOOL)needImgHidden{
    _needImgHidden = needImgHidden;
    self.mainImgView.hidden = _needImgHidden;
}

#pragma mark----懒加载----
- (UIImageView *)mainImgView{
    if (_mainImgView == nil) {
        UIImageView *imgView = [[UIImageView alloc]initWithImage:image(@"bg_noData")];
        _mainImgView = imgView;
        [self addSubview:_mainImgView];
    }
    return _mainImgView;
}
- (UILabel *)mainLabel{
    if (_mainLabel == nil) {
        UILabel *label = [UILabel new];
        _mainLabel = label;
        _mainLabel.text = @"暂无内容~";
        _mainLabel.font = RegularFont(14);
        _mainLabel.textColor = Color(@"#666666");
        [_mainLabel sizeToFit];
        [self addSubview:_mainLabel];
    }
    return _mainLabel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
