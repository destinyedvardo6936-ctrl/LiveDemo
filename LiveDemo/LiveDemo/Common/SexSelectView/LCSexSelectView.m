//
//  LCSexSelectView.m
//  LiveDemo
//
//  Created by mrgao on 2022/11/24.
//

#import "LCSexSelectView.h"
#import "LCLocationSelectCell.h"

@interface LCSexSelectView ()
@property (nonatomic , weak) UIView *contentView;
@property (nonatomic , weak) UIButton *closeBtn;
@property (nonatomic , weak) UILabel *tipLabel;

@end
@implementation LCSexSelectView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = ColorAlpha(@"#000000", 0.5);
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(kViewMargin));
            make.right.equalTo(-kUI_Width(kViewMargin));
            make.height.equalTo(kUI_Width(667));
            make.top.equalTo(kUI_Width(135));
        }];
        [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(kViewMargin));
            make.top.equalTo(kUI_Width(10));
            make.height.equalTo(kUI_Width(12));
            make.right.equalTo(-kUI_Width(kViewMargin));
        }];
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(kUI_Width(8));
            make.right.equalTo(-kUI_Width(8));
            make.width.height.equalTo(kUI_Width(16));
        }];
        [self createBtn];
    }
    return self;
}
- (void)createBtn{

    for (NSInteger i = 0; i < 3; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageWithColor:Color(@"#EEEEEE") size:CGSizeMake(kUI_Width(78), kUI_Width(28))] forState:UIControlStateNormal];
        [btn setImage:image(@"icon_homeLocationBg") forState:UIControlStateSelected];
        btn.layer.cornerRadius = kUI_Width(28)/2.0;
        btn.clipsToBounds = YES;
        btn.tag = 200 + i;
        NSString *nameStr = [NSString stringWithFormat:@"sexSelectText%ld",i + 1];
        [btn setTitle:KLanguage(nameStr) forState:UIControlStateNormal];
        [btn setTitle:KLanguage(nameStr) forState:UIControlStateSelected];
        [self.contentView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(kViewMargin) + i * kUI_Width(78) + i * kUI_Width(5));
            make.width.equalTo(kUI_Width(78));
            make.height.equalTo(kUI_Width(28));
            make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(kUI_Width(10));
        }];
        WS(weakSelf)
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIButton * _Nullable x) {
            weakSelf.currentSex = x.titleLabel.text;
            [weakSelf resetBtnStatus];
        }];
    }
}
- (void)resetBtnStatus{
    for (NSInteger i = 200; i < 203; i ++) {
        UIButton *btn = [self.contentView viewWithTag:i];
        if([btn.titleLabel.text isEqualToString:self.currentSex]){
            btn.selected = YES;
        }else{
            btn.selected = NO;
        }
    }
}
- (void)setCurrentSex:(NSString *)currentSex{
    _currentSex = [currentSex copy];
    [self resetBtnStatus];
}

#pragma mark---- 懒加载 ----
- (UIView *)contentView{
    if (_contentView == nil){
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = Color(@"#FFFFFF");
        view.layer.cornerRadius = kUI_Width(4);
        view.clipsToBounds = YES;
        [self addSubview:view];
        _contentView = view;
    }
    return _contentView;
}

- (UIButton *)closeBtn{
    if(_closeBtn == nil){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:image(@"icon_locationClose") forState:UIControlStateNormal];
        _closeBtn = btn;
        [self.contentView addSubview:_closeBtn];
        WS(weakSelf)
        [[_closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if(weakSelf.selectBlock){
                weakSelf.selectBlock(weakSelf.currentSex);
            }
            [UIView animateWithDuration:0.15 animations:^{
                [weakSelf removeFromSuperview];
            }];
        }];
    }
    return _closeBtn;
}

- (UILabel *)tipLabel{
    if (_tipLabel == nil){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = RegularFont(12);
        label.textColor = Color(@"#333333");
        label.text = KLanguage(@"性别");
        [self.contentView addSubview:label];
        _tipLabel = label;
    }
    return _tipLabel;
}


@end
