//
//  LCLiveToolView.m
//  LiveDemo
//
//  Created by mrgao on 2022/11/27.
//

#import "LCLiveToolView.h"
#import "LCGameConfigManager.h"
@interface LCLiveToolView ()
@property (nonatomic , weak) UIButton *commmentBtn;
@property (nonatomic , weak) UIButton *kefuBtn;
@property (nonatomic , weak) UIButton *activtyBtn;
@property (nonatomic , weak) UIButton *giftBtn;
@property (nonatomic , weak) UIButton *gameBtn;
@property (nonatomic , weak) UIButton *closeBtn;

@end
@implementation LCLiveToolView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.commmentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(kViewMargin));
            make.bottom.equalTo(-kUI_Width(10));
            make.height.equalTo(kUI_Width(36));
            make.width.equalTo(kUI_Width(120));
        }];
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-kUI_Width(kViewMargin));
            make.bottom.equalTo(-kUI_Width(10));
            make.height.equalTo(kUI_Width(36));
            make.width.equalTo(kUI_Width(36));
        }];
        [self.gameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.closeBtn.mas_left).offset(-kUI_Width(10));
            make.bottom.equalTo(-kUI_Width(10));
            make.height.equalTo(kUI_Width(36));
            make.width.equalTo(kUI_Width(36));
        }];
        self.gameBtn.hidden =  ![LCGameConfigManager shareManager].gameStatus ;
        [self.giftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            if(self.gameBtn.hidden){
                make.right.mas_equalTo(self.closeBtn.mas_left).offset(-kUI_Width(10));
            }else{
                make.right.mas_equalTo(self.gameBtn.mas_left).offset(-kUI_Width(10));
            }
           
            make.bottom.equalTo(-kUI_Width(10));
            make.height.equalTo(kUI_Width(36));
            make.width.equalTo(kUI_Width(36));
        }];
        [self.activtyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.giftBtn.mas_left).offset(-kUI_Width(10));
            make.bottom.equalTo(-kUI_Width(10));
            make.height.equalTo(kUI_Width(36));
            make.width.equalTo(kUI_Width(36));
        }];
        [self.kefuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.activtyBtn.mas_left).offset(-kUI_Width(10));
            make.bottom.equalTo(-kUI_Width(10));
            make.height.equalTo(kUI_Width(36));
            make.width.equalTo(kUI_Width(36));
        }];
    }
    return self;
}
#pragma mark---- 懒加载 ----
- (UIButton *)commmentBtn{
    if (!_commmentBtn){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:ColorAlpha(@"#000000", 0.3)];
        btn.layer.cornerRadius = kUI_Width(36)/2.0;
        
        [self addSubview:btn];
        WS(weakSelf)
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (weakSelf.btnClickBlock){
                weakSelf.btnClickBlock(0);
            }
        }];
        _commmentBtn = btn;
        UIImageView *imgView = [[UIImageView alloc]initWithImage:image(@"icon_liveCommentImg")];
        [_commmentBtn addSubview:imgView];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = MediumFont(12);
        label.text = KLanguage(@"说点什么…");
        label.textColor = Color(@"#CECECE");
        [_commmentBtn addSubview:label];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(8));
            make.width.height.equalTo(kUI_Width(24));
            make.centerY.equalTo(0);
        }];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imgView.mas_right).offset(kUI_Width(8));
            make.height.equalTo(kUI_Width(12));
            make.centerY.equalTo(0);
        }];
        
    }
    return _commmentBtn;
}
- (UIButton *)closeBtn{
    if (!_closeBtn){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:ColorAlpha(@"#000000", 0.3)];
        btn.layer.cornerRadius = kUI_Width(36)/2.0;
        
        [self addSubview:btn];
        WS(weakSelf)
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (weakSelf.btnClickBlock){
                weakSelf.btnClickBlock(5);
            }
        }];
        _closeBtn = btn;
        UIImageView *imgView = [[UIImageView alloc]initWithImage:image(@"icon_liveCloseBtn")];
        [_closeBtn addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.centerX.equalTo(0);
            make.width.height.equalTo(kUI_Width(15));
        }];
    }
    return _closeBtn;
}
- (UIButton *)gameBtn{
    if (!_gameBtn){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:ColorAlpha(@"#000000", 0.3)];
        btn.layer.cornerRadius = kUI_Width(36)/2.0;
        
        [self addSubview:btn];
        WS(weakSelf)
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (weakSelf.btnClickBlock){
                weakSelf.btnClickBlock(4);
            }
        }];
        _gameBtn = btn;
        UIImageView *imgView = [[UIImageView alloc]initWithImage:image(@"icon_liveGameToolImg")];
        [_gameBtn addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.centerX.equalTo(0);
            make.width.height.equalTo(kUI_Width(24));
        }];
    }
    return _gameBtn;
}
- (UIButton *)giftBtn{
    if (!_giftBtn){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:ColorAlpha(@"#000000", 0.3)];
        
        btn.layer.cornerRadius = kUI_Width(36)/2.0;
        btn.clipsToBounds = YES;
        [self addSubview:btn];
        WS(weakSelf)
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (weakSelf.btnClickBlock){
                weakSelf.btnClickBlock(3);
            }
        }];
        _giftBtn = btn;
        UIImageView *imgView = [[UIImageView alloc]initWithImage:image(@"icon_liveGiftToolImg")];
        [_giftBtn addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.centerX.equalTo(0);
            make.width.height.equalTo(kUI_Width(24));
        }];
    }
    return _giftBtn;
}
- (UIButton *)activtyBtn{
    if (!_activtyBtn){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:ColorAlpha(@"#000000", 0.3)];
        
        btn.layer.cornerRadius = kUI_Width(36)/2.0;
        btn.clipsToBounds = YES;
        [self addSubview:btn];
        WS(weakSelf)
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (weakSelf.btnClickBlock){
                weakSelf.btnClickBlock(2);
            }
        }];
        _activtyBtn = btn;
        UIImageView *imgView = [[UIImageView alloc]initWithImage:image(@"icon_liveActivityToolImg")];
        [_activtyBtn addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.centerX.equalTo(0);
            make.width.height.equalTo(kUI_Width(24));
        }];
    }
    return _activtyBtn;
}
- (UIButton *)kefuBtn{
    if (!_kefuBtn){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:ColorAlpha(@"#000000", 0.3)];
        
        btn.layer.cornerRadius = kUI_Width(36)/2.0;
        btn.clipsToBounds = YES;
        [self addSubview:btn];
        WS(weakSelf)
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (weakSelf.btnClickBlock){
                weakSelf.btnClickBlock(1);
            }
        }];
        _kefuBtn = btn;
        UIImageView *imgView = [[UIImageView alloc]initWithImage:image(@"icon_liveKefuToolImg")];
        [_kefuBtn addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.centerX.equalTo(0);
            make.width.height.equalTo(kUI_Width(24));
        }];
    }
    return _kefuBtn;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
