//
//  LCGameOptionView.m
//  LiveDemo
//
//  Created by mrgao on 2023/3/21.
//

#import "LCGameOptionView.h"


@interface LCGameOptionView ()<UIGestureRecognizerDelegate>
@property (nonatomic , weak) UIView *contentView;

@end
@implementation LCGameOptionView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        NSArray *titleArr = @[KLanguage(@"玩法说明"),KLanguage(@"投注记录"),KLanguage(@"开奖记录"),KLanguage(@"充值")];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(kNavBarHeight);
            make.right.equalTo(0);
            make.width.equalTo(kUI_Width(90));
            make.height.equalTo(kUI_Width(32) * titleArr.count);
        }];
        for (NSInteger i = 0; i < titleArr.count; i ++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:titleArr[i] forState:UIControlStateNormal];
            [btn setTitleColor:Color(@"#333333") forState:UIControlStateNormal];
            btn.tag = 200 + i;
            btn.titleLabel.font = RegularFont(14);
            [self.contentView addSubview:btn];
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectZero];
            lineView.backgroundColor = ColorAlpha(@"#CCCCCC", 0.2);
            [self.contentView addSubview:lineView];
            if(i == titleArr.count - 1){
                lineView.hidden = YES;
            }else{
                lineView.hidden = NO;
            }
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(kUI_Width(32));
                make.left.right.equalTo(0);
                make.top.equalTo(kUI_Width(32)*i);
            }];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(1);
                make.bottom.mas_equalTo(btn.mas_bottom);
                make.left.right.equalTo(0);
            }];
            WS(weakSelf)
            [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                if(weakSelf.btnClickBlock){
                    weakSelf.btnClickBlock(x.tag - 200);
                }
            }];
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftButtonWithButton)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}
- (void)leftButtonWithButton{
    [self removeFromSuperview];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:self.contentView]) {
    
        return NO;
    }
    
    return YES;
}
#pragma mark---- 懒加载 ----
- (UIView *)contentView{
    if (_contentView == nil){
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = Color(@"#FFFFFF");
//        view.layer.cornerRadius = kUI_Width(8);
        view.clipsToBounds = YES;
        [self addSubview:view];
        _contentView = view;
    }
    return _contentView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
