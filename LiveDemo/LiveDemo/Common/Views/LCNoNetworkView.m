//
//  LCNoNetworkView.m
//  LCHeadlines
//
//  Created by mrgao on 2020/1/6.
//  Copyright © 2020 mrgao. All rights reserved.
//

#import "LCNoNetworkView.h"

@interface LCNoNetworkView ()
@property (nonatomic,weak)UIImageView *mainImgView;
@property (nonatomic,weak)UILabel *mainLabel;
@property (nonatomic,weak)UIButton *reloadBtn;
@end
@implementation LCNoNetworkView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = Color(@"#FFFFFF");
        [self.mainImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.centerY.equalTo(-kUI_Width(42));
        }];
        [self.mainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.top.mas_equalTo(self.mainImgView.mas_bottom).offset(kUI_Width(18));
        }];
        [self.reloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.top.mas_equalTo(self.mainLabel.mas_bottom).offset(kUI_Width(18));
            make.width.equalTo(kUI_Width(140));
            make.height.equalTo(kUI_Width(28));
        }];
    }
    return self;
}
- (void)buttonClicked{
    self.hidden = YES;
    if (self.reconnectBlock) {
        self.reconnectBlock();
    }
}
#pragma mark----懒加载----
- (UIImageView *)mainImgView{
    if (_mainImgView == nil) {
        UIImageView *imgView = [[UIImageView alloc]initWithImage:image(@"bg_wangluoyichang")];
        _mainImgView = imgView;
        [self addSubview:_mainImgView];
    }
    return _mainImgView;
}
- (UILabel *)mainLabel{
    if (_mainLabel == nil) {
        UILabel *label = [UILabel new];
        _mainLabel = label;
        _mainLabel.text = @"网络不见啦！";
        _mainLabel.font = RegularFont(14);
        _mainLabel.textColor = Color(@"#A1A5B7");
        [_mainLabel sizeToFit];
        [self addSubview:_mainLabel];
    }
    return _mainLabel;
}
- (UIButton *)reloadBtn{
    if (_reloadBtn == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _reloadBtn = btn;
        [_reloadBtn setTitle:@"重新加载" forState:UIControlStateNormal];
        _reloadBtn.titleLabel.font = RegularFont(12);
        [_reloadBtn setTitleColor:Color(@"#A1A5B7") forState:UIControlStateNormal];
        _reloadBtn.layer.cornerRadius = kUI_Width(14);
        _reloadBtn.layer.borderWidth = 1;
        _reloadBtn.layer.borderColor = Color(@"#CED1DD").CGColor;
        [self addSubview:_reloadBtn];
        [_reloadBtn addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reloadBtn;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
