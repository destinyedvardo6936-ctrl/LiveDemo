//
//  LCNoticeView.m
//  LiveDemo
//
//  Created by mrgao on 2022/11/25.
//

#import "LCNoticeView.h"

@interface LCNoticeView ()
@property (nonatomic , weak) UIView *contentView;
@property (nonatomic , weak) UIButton *closeBtn;
@property (nonatomic , weak) UIImageView *headerImgView;
@property (nonatomic , weak) UILabel *tipLabel;
@property (nonatomic , weak) UILabel *titleLabel;
@property (nonatomic , weak) UITextView *textContentView;
@end
@implementation LCNoticeView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = ColorAlpha(@"#000000", 0.5);
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(kViewMargin));
            make.right.equalTo(-kUI_Width(kViewMargin));
            make.height.equalTo(kUI_Width(386));
            make.top.equalTo(kUI_Width(131));
        }];
        [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(0);
            make.height.equalTo(kUI_Width(87));
            
        }];
        [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.top.equalTo(kUI_Width(22));
            make.height.equalTo(kUI_Width(34));
            
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.height.equalTo(kUI_Width(14));
            make.top.mas_equalTo(self.headerImgView.mas_bottom).offset(kUI_Width(10));
        }];
        
        [self.textContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(kViewMargin));
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kUI_Width(8));
            make.bottom.equalTo(-kUI_Width(8));
            make.right.equalTo(-kUI_Width(kViewMargin));
        }];
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_bottom).offset(kUI_Width(8));
            make.centerX.equalTo(0);
            make.width.height.equalTo(kUI_Width(28));
        }];
        
    }
    return self;
}


#pragma mark---- 懒加载 ----
- (UIView *)contentView{
    if (_contentView == nil){
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = Color(@"#FFFFFF");
        view.layer.cornerRadius = kUI_Width(8);
        view.clipsToBounds = YES;
        [self addSubview:view];
        _contentView = view;
    }
    return _contentView;
}
- (UIImageView *)headerImgView{
    if (!_headerImgView ){
        UIImageView *imgView = [[UIImageView alloc]initWithImage:image(@"icon_noticeHeaderImg")];
        [self.contentView addSubview:imgView];
        _headerImgView = imgView;
    }
    return _headerImgView;
}
- (UILabel *)tipLabel{
    if (_tipLabel == nil){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = BoldFont(24);
        label.textColor = Color(@"#FFFFFF");
        label.text = KLanguage(@"公告");
        [self.headerImgView addSubview:label];
        _tipLabel = label;
    }
    return _tipLabel;
}
- (UILabel *)titleLabel{
    if (_titleLabel == nil){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = BoldFont(14);
        label.textColor = Color(@"#333333");
//        label.text = KLanguage(@"男");
        [self.contentView addSubview:label];
        _titleLabel = label;
    }
    return _titleLabel;
}
- (UITextView *)textContentView{
    if (!_textContentView){
        UITextView *textView = [[UITextView alloc]initWithFrame:CGRectZero];
        textView.editable = NO;
        textView.font = RegularFont(14);
        textView.textColor = Color(@"#333333");
        [self.contentView addSubview:textView];
        _textContentView = textView;
        
    }
    return _textContentView;
}
- (UIButton *)closeBtn{
    if(_closeBtn == nil){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:image(@"icon_noticeCloseImg") forState:UIControlStateNormal];
        _closeBtn = btn;
        [self.contentView addSubview:_closeBtn];
        WS(weakSelf)
        [[_closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            
            [UIView animateWithDuration:0.15 animations:^{
                [weakSelf removeFromSuperview];
            }];
        }];
    }
    return _closeBtn;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
