//
//  LCLiveGiftSelectView.m
//  LiveDemo
//
//  Created by mrgao on 2023/3/14.
//

#import "LCLiveGiftSelectView.h"

@interface LCLiveGiftSelectView ()<UIGestureRecognizerDelegate>
@property (nonatomic , weak) UIView *contentView;
@property (nonatomic , strong) NSMutableArray *dataArray;

@end
@implementation LCLiveGiftSelectView

- (instancetype)initWithFrame:(CGRect)frame contentOrigin:(CGPoint)contentOrigin titles:(NSArray *)titles
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.dataArray = [NSMutableArray arrayWithArray:titles];
        
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(kUI_Width(47));
            make.height.equalTo(kUI_Width(17) * self.dataArray.count);
            make.bottom.equalTo(contentOrigin.y-SCREEN_HEIGHT);
            make.right.equalTo(contentOrigin.x - SCREEN_WIDTH);
        }];
        [self createBtnWithTitles:titles];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftButtonWithButton)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}
- (void)leftButtonWithButton{
    if(self.dismissBlock){
        self.dismissBlock();
    }
    [self removeFromSuperview];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:self.contentView]) {
    
        return NO;
    }
    
    return YES;
}
- (void)createBtnWithTitles:(NSArray *)titles{
   
    for (NSString *title in titles) {
        NSInteger index = [titles indexOfObject:title];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
        btn.titleLabel.font = RegularFont(12);
        btn.tag = 200 + index;
        [self.contentView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(kUI_Width(17));
            make.top.equalTo(index * kUI_Width(17));
            make.left.right.equalTo(0);
        }];
        WS(weakSelf)
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            
            if(weakSelf.selectBlock){
                weakSelf.selectBlock(weakSelf.dataArray[x.tag - 200]);
            }
            [weakSelf leftButtonWithButton];
        }];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectZero];
        lineView.backgroundColor = ColorAlpha(@"#979797", 0.38);
        [self.contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.height.equalTo(1);
            make.top.mas_equalTo(btn.mas_bottom);
        }];
        lineView.hidden = index == titles.count - 1;
    }
}
#pragma mark---- 懒加载 ----
- (UIView *)contentView{
    if (_contentView == nil){
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = ColorAlpha(@"#000000", 0.6);
        view.layer.cornerRadius = kUI_Width(4);
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
