//
//  LCUploadProgressView.m
//  LCHeadlines
//
//  Created by mrgao on 2020/10/27.
//  Copyright © 2020 WY. All rights reserved.
//

#import "LCUploadProgressView.h"

@interface LCUploadProgressView ()
@property (nonatomic,weak)UIView *contentView;
@property (nonatomic,weak)UILabel *tipLabel;
@property (nonatomic,weak)UIView *backProgressView;
@property (nonatomic,weak)UIView *progressView;
@property (nonatomic,weak)UILabel *progressLabel;
@property (nonatomic,weak)UIView *lineView;
@property (nonatomic,weak)UIButton *cancelBtn;
@end
@implementation LCUploadProgressView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = ColorAlpha(@"#000000", 0.5);
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(kUI_Width(230));
            make.height.equalTo(kUI_Width(138));
            make.center.equalTo(0);
        }];
        [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(kUI_Width(15));
            make.height.equalTo(kUI_Width(20));
            make.left.right.equalTo(0);
        }];
        [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-kUI_Width(kViewMargin));
            make.height.equalTo(kUI_Width(20));
            make.centerY.mas_equalTo(self.backProgressView.mas_centerY);
        }];
        [self.backProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(kViewMargin));
            make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(kUI_Width(12));
            make.height.equalTo(kUI_Width(6));
            make.width.equalTo(kUI_Width(136));
        }];
        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(kViewMargin));
            make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(kUI_Width(12));
            make.height.equalTo(kUI_Width(6));
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(-kUI_Width(49));
            make.left.right.equalTo(0);
            make.height.equalTo(1);
        }];
        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(0);
            make.height.equalTo(kUI_Width(49));
        }];
    }
    return self;
}
- (void)setProgress:(double)progress{
    _progress = progress;
    self.progressLabel.text = [NSString stringWithFormat:@"%.1f%%",_progress * 100];
    [self.progressView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(kUI_Width(136) * _progress);
    }];
}
- (void)cancelBtnClicked{
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}
#pragma mark----懒加载----
- (UIView *)contentView{
    if (_contentView == nil) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        _contentView = view;
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = kUI_Width(8);
        _contentView.clipsToBounds = YES;
        [self addSubview:_contentView];
    }
    return _contentView;
}
- (UILabel *)tipLabel{
    if (_tipLabel == nil) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        _tipLabel = label;
        _tipLabel.font = RegularFont(14);
        _tipLabel.textColor = Color(@"#000000");
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.text = @"上传中";
        [self.contentView addSubview:_tipLabel];
    }
    return _tipLabel;
}
- (UIView *)backProgressView{
    if (_backProgressView == nil) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        _backProgressView = view;
        _backProgressView.backgroundColor = Color(@"#D2E4FF");
        [self.contentView addSubview:_backProgressView];
    }
    return _backProgressView;
}
- (UIView *)progressView{
    if (_progressView == nil) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        _progressView = view;
        _progressView.backgroundColor = Color(@"#0266FF");
        [self.contentView addSubview:_progressView];
    }
    return _progressView;
}
- (UILabel *)progressLabel{
    if (_progressLabel == nil) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        _progressLabel = label;
        _progressLabel.text = @"0%";
        _progressLabel.font = RegularFont(14);
        _progressLabel.textColor = Color(@"#000000");
        [self.contentView addSubview:_progressLabel];
    }
    return _progressLabel;
}
- (UIView *)lineView{
    if (_lineView == nil) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        _lineView = view;
        _lineView.backgroundColor = Color(@"#F4F6FB");
        [self.contentView addSubview:_lineView];
    }
    return _lineView;
}
- (UIButton *)cancelBtn{
    if (_cancelBtn == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn  =btn;
        _cancelBtn.titleLabel.font = RegularFont(12);
        [_cancelBtn setTitle:@"取消上传" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:Color(@"#777F8F") forState:UIControlStateNormal];
        [self.contentView addSubview:_cancelBtn];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
