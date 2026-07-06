//
//  LCBaseNavigationView.m
//  liveCommon
//
//  Created by mrgao on 2022/9/29.
//

#import "LCBaseNavigationView.h"

@interface LCBaseNavigationView ()
@property (nonatomic,weak)UIView *bottomView;
@property (nonatomic,weak)UIButton *leftButton;
@property (nonatomic,weak)UIButton *rightButton;
@property (nonatomic,weak)UILabel *centerLabel;

@property (nonatomic,assign)LCBaseNavigationViewLeftType leftType;
@property (nonatomic,assign)LCBaseNavigationViewRightType rightType;
@end
@implementation LCBaseNavigationView
- (instancetype)initWithFrame:(CGRect)frame
                        title:(NSString *)title
                     leftType:(LCBaseNavigationViewLeftType)leftType  rightType:(LCBaseNavigationViewRightType)rightType{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = Color(@"#FFFFFF");
        _leftType = leftType;
        _rightType = rightType;
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(0);
            make.top.equalTo(kStatusBarHeight);
        }];
        [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(0);
            make.width.equalTo(kUI_Width(45));
        }];
        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(0);
            make.width.equalTo(kUI_Width(45));
        }];
        [self.centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(0);
            make.left.mas_equalTo(self.leftButton.mas_right);
            make.right.mas_equalTo(self.rightButton.mas_left);
        }];
        [self addLeftButtonSubViews];
        [self addRightButtonSubViews];
        self.centerLabel.text = title;
    }
    return self;
}
- (void)setBottomBackgroundColor:(UIColor *)color{
    self.backgroundColor = color;
    self.bottomView.backgroundColor = color;
}
- (void)setLeftButtonType:(LCBaseNavigationViewLeftType)type{
    _leftType = type;
    [self addLeftButtonSubViews];
}
- (void)setRightButtonType:(LCBaseNavigationViewRightType)type{
    _rightType = type;
    [self addRightButtonSubViews];
}
- (void)setCustomLeftTitle:(NSString *)leftTitle{
    UILabel *label = [self.leftButton viewWithTag:201];
    label.text = leftTitle;
    
}
- (void)setCustomRightTitle:(NSString *)rightTitle{
    UILabel *label = [self.rightButton viewWithTag:201];
    label.text = rightTitle;
}
- (void)setCustomLeftTextColor:(UIColor *)color{
    UILabel *label = [self.leftButton viewWithTag:201];
    label.textColor = color;
}
- (void)setCustomRightTextColor:(UIColor *)color{
    UILabel *label = [self.rightButton viewWithTag:201];
    label.textColor = color;
}

- (void)setCustomLeftTextFont:(UIFont *)font{
    UILabel *label = [self.leftButton viewWithTag:201];
    label.font = font;
}
- (void)setCustomRightTextFont:(UIFont *)font{
    UILabel *label = [self.rightButton viewWithTag:201];
    label.font = font;
}

- (void)setCenterLabelText:(NSString *)title{
    self.centerLabel.text = title;
}
- (void)setCenterLabelTextColor:(UIColor *)color{
    self.centerLabel.textColor = color;
}
- (void)setCenterLabelFont:(UIFont *)font{
    self.centerLabel.font = font;
}
- (void)setCustomLeftImageStr:(NSString *)leftImgStr{
    UIImageView *imgView = [self.leftButton viewWithTag:200];
    imgView.image = image(leftImgStr);
    
}
- (void)setCustomRightImageStr:(NSString *)leftImgStr{
    UIImageView *imgView = [self.rightButton viewWithTag:200];
    imgView.image = image(leftImgStr);
//    imgView.backgroundColor = [UIColor greenColor];
  
}
- (void)addLeftButtonSubViews{
    for (UIView *view in self.leftButton.subviews) {
        if (view.tag == 200 || view.tag == 201) {
            [view removeFromSuperview];
        }
        
    }
    switch (_leftType) {
        case LCBaseNavigationViewLeftType_None:
        {
            
        }
            break;
        case LCBaseNavigationViewLeftType_BlackBack:
        {
            UIImageView *imgView = [[UIImageView alloc]initWithImage:image(@"ic_blackBack")];
            imgView.tag = 200;
            [self.leftButton addSubview:imgView];
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(kUI_Width(kViewMargin));
                make.centerY.equalTo(0);
                make.width.height.equalTo(kUI_Width(20));
            }];
        }
            break;
        case LCBaseNavigationViewLeftType_WhiteBack:
        {
            UIImageView *imgView = [[UIImageView alloc]initWithImage:image(@"ic_whiteBack")];
            imgView.tag = 200;
            [self.leftButton addSubview:imgView];
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(kUI_Width(kViewMargin));
                make.centerY.equalTo(0);
                make.width.height.equalTo(kUI_Width(20));
            }];
        }
            break;
        case LCBaseNavigationViewLeftType_Text:
        {
            UILabel *label = [UILabel new];
            label.font = RegularFont(14);
            label.textColor = Color(@"#293753");
            label.tag = 201;
            label.text = @"";
            [self.leftButton addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(kUI_Width(kViewMargin));
                make.centerY.equalTo(0);
                
            }];
        }
            break;
        case LCBaseNavigationViewLeftType_Image:
        {
            UIImageView *imgView = [[UIImageView alloc]initWithImage:image(@"")];
            imgView.tag = 200;
            [self.leftButton addSubview:imgView];
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(kUI_Width(kViewMargin));
                make.centerY.equalTo(0);
                make.width.height.equalTo(kUI_Width(20));
            }];
        }
            break;
        default:
            break;
    }
}
- (void)addRightButtonSubViews{
    for (UIView *view in self.rightButton.subviews) {
        if (view.tag == 200 || view.tag == 201) {
            [view removeFromSuperview];
        }
        
    }
    switch (_rightType) {
        case LCBaseNavigationViewRightType_None:
        {
            
        }
            break;
        case LCBaseNavigationViewRightType_Text:
        {
            UILabel *label = [UILabel new];
            label.font = RegularFont(14);
            label.textColor = Color(@"293753");
            label.tag = 201;
            label.text = @"";
            [self.rightButton addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(-kUI_Width(kViewMargin));
                make.centerY.equalTo(0);
            }];
        }
            break;
        case LCBaseNavigationViewRightType_Image:
        {
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
            imgView.tag = 200;
            
            [self.rightButton addSubview:imgView];
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(-kUI_Width(kViewMargin));
                make.centerY.equalTo(0);
                make.width.height.equalTo(kUI_Width(25));
            }];
        }
            break;
        default:
            break;
    }
}


- (void)leftBtnClicked{
    if (_leftType != LCBaseNavigationViewLeftType_None) {
        if ([_delegate respondsToSelector:@selector(leftButtonClicked)]) {
            [_delegate leftButtonClicked];
        }
    }
    
}
- (void)rightBtnClicked{
    if (_rightButton != LCBaseNavigationViewRightType_None) {
        if ([_delegate respondsToSelector:@selector(rightButtonClicked)]) {
               [_delegate rightButtonClicked];
           }
    }
}
- (NSString *)centerTitle{
    return self.centerLabel.text;
}
#pragma mark----懒加载----
- (UIView *)bottomView{
    if (_bottomView == nil) {
        UIView *view = [UIView new];
        _bottomView = view;
        _bottomView.backgroundColor = Color(@"FFFFFF");
        [self addSubview:_bottomView];
    }
    return _bottomView;
}
- (UIButton *)leftButton{
    if (_leftButton == nil) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftButton = button;
        [self.bottomView addSubview:_leftButton];
         [_leftButton addTarget:self action:@selector(leftBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}
- (UIButton *)rightButton{
    if (_rightButton == nil) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton = button;
        [self.bottomView addSubview:_rightButton];
         [_rightButton addTarget:self action:@selector(rightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}
- (UILabel *)centerLabel{
    if (_centerLabel == nil) {
        UILabel *label = [UILabel new];
        _centerLabel = label;
        _centerLabel.font = RegularFont(16);
        _centerLabel.textColor = Color(@"000000");
        _centerLabel.textAlignment = NSTextAlignmentCenter;
        [self.bottomView addSubview:_centerLabel];
    }
    return _centerLabel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
