//
//  LCHomeFollowListHeaderView.m
//  LiveDemo
//
//  Created by mrgao on 2022/11/23.
//

#import "LCHomeFollowListHeaderView.h"

@interface LCHomeFollowListHeaderView ()
@property (nonatomic , weak) UIImageView *mainImgView;
@property (nonatomic , weak) UILabel *mainLabel;
@property (nonatomic , weak) UIButton *replaceBtn;

@end
@implementation LCHomeFollowListHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame: frame];
    if (self){
        [self.mainImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(kViewMargin));
            make.top.equalTo(kUI_Width(10));
            make.width.height.equalTo(kUI_Width(25));
        }];
        [self.mainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mainImgView.mas_centerY);
            make.height.equalTo(kUI_Width(16));
            make.left.mas_equalTo(self.mainImgView.mas_right).offset(kUI_Width(4));
            make.right.equalTo(-kUI_Width(kViewMargin));
        }];
        [self.replaceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-kUI_Width(kViewMargin));
            make.centerY.mas_equalTo(self.mainImgView.mas_centerY);
            make.width.equalTo(kUI_Width(60));
            make.height.equalTo(kUI_Width(24));
        }];
    }
    return self;
}
- (void)setTitleStr:(NSString *)titleStr{
    _titleStr = [titleStr copy];
    self.mainLabel.text = _titleStr;
}
- (void)setImage:(UIImage *)image{
    _image = image;
    self.mainImgView.image = image;
}
- (void)setNeedReplace:(BOOL)needReplace{
    _needReplace = needReplace;
    self.replaceBtn.hidden = !_needReplace;
}
#pragma mark---- 懒加载 ----
- (UIImageView *)mainImgView{
    if (_mainImgView == nil){
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
//        imgView.image = image(@"");
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        _mainImgView = imgView;
        [self addSubview:_mainImgView];
    }
    return _mainImgView;
}
- (UILabel *)mainLabel{
    if (!_mainLabel){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = BoldFont(16);
        label.textColor = Color(@"#333333");
        _mainLabel = label;
        [self addSubview:_mainLabel];
    }
    return _mainLabel;
}
- (UIButton *)replaceBtn{
    if (_replaceBtn == nil){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btn];
        btn.titleLabel.font = BoldFont(14);
        [btn setTitle:KLanguage(@"换一批") forState:UIControlStateNormal];
        [btn setTitleColor:Color(@"#FF86BA") forState:UIControlStateNormal];
        btn.layer.cornerRadius = kUI_Width(24)/2.0;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = Color(@"#FF86BA").CGColor;
        btn.clipsToBounds = YES;
        _replaceBtn = btn;
        WS(weakSelf)
        [[_replaceBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (weakSelf.replaceClickBlock){
                weakSelf.replaceClickBlock();
            }
        }];
    }
    return _replaceBtn;
}
@end
