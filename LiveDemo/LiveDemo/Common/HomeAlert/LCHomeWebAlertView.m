//
//  LCHomeWebAlertView.m
//  LiveDemo
//
//  Created by mrgao on 2024/7/28.
//

#import "LCHomeWebAlertView.h"
#import "LCWebContainerView.h"

@interface LCHomeWebAlertView ()<LCWebContainerViewDelegate>
@property (nonatomic , weak) UIView *contentView;
//@property (nonatomic , weak) UIButton *closeBtn;
@property (nonatomic , weak) UIImageView *headerImgView;
@property (nonatomic , weak) UILabel *tipLabel;

@property (nonatomic,weak)LCWebContainerView *webView;
@property (nonatomic , weak) UIButton *closeBtn;


@end
@implementation LCHomeWebAlertView
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
       
        
        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(kViewMargin));
            make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(kUI_Width(15));
            make.bottom.mas_equalTo(self.closeBtn.mas_top).offset(-kUI_Width(8));
            make.right.equalTo(-kUI_Width(kViewMargin));
        }];
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.width.height.equalTo(kUI_Width(64));
            make.top.mas_equalTo(self.contentView.mas_bottom).offset(kUI_Width(15));
        }];
        
        
    }
    return self;
}
- (void)setWebText:(NSString *)webText{
    _webText = [webText copy];
    [self.webView loadHtmlString:_webText];
    
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

- (LCWebContainerView *)webView{
    if(_webView == nil){
        LCWebContainerView *view = [[LCWebContainerView alloc]initWithFrame:CGRectZero];
        view.webContainerDelegate = self;
        [self.contentView addSubview:view];
        _webView = view;
    }
    return _webView;
}
- (UIButton *)closeBtn{
    if (!_closeBtn){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:image(@"icon_homeAlertClose") forState:UIControlStateNormal];
        btn.clipsToBounds = YES;
        [self addSubview:btn];
        _closeBtn = btn;
        WS(weakSelf)
        [[_closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if(weakSelf.closeBlock){
                weakSelf.closeBlock();
            }
            [weakSelf removeFromSuperview];
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
