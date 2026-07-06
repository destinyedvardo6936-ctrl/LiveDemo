//
//  LCProtocolView.m
//  LCHeadlines
//
//  Created by mrgao on 2020/2/24.
//  Copyright © 2020 WY. All rights reserved.
//

#import "LCProtocolView.h"
#import "LCShelterGradientView.h"
#import "LCLocalDataTools.h"
@interface LCProtocolView ()
@property (nonatomic,weak)UIView *contentView;
@property (nonatomic,weak)UILabel *titleLabel;
@property (nonatomic,weak)UILabel *subTitleLabel;
@property (nonatomic,weak)UILabel *protocolLabel;
@property (nonatomic,weak)UILabel *andLabel;
@property (nonatomic,weak)UILabel *policyLabel;
@property (nonatomic,weak)UITextView *textView;
@property (nonatomic,weak)LCShelterGradientView *shelterView;

@property (nonatomic,weak)UIView *lineView;
@property (nonatomic,weak)UIButton *doneButton;
//@property (nonatomic,weak)UIView *contentView;
//@property (nonatomic,weak)UIImageView *shelterView;
//@property (nonatomic,weak)LCWebContainerView *webView;
//@property (nonatomic,weak)UIView *lineView;
//@property (nonatomic,weak)UIButton *doneButton;
//@property (nonatomic,strong)TTWebViewJavascriptBridge *bridge;
@end
@implementation LCProtocolView
-(instancetype)init
{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
       
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.windowLevel = UIWindowLevelAlert + 1;
        self.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
        
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerY.equalTo(0);
            make.left.equalTo(kUI_Width(40));
            make.right.equalTo(-kUI_Width(40));
            make.height.equalTo(kUI_Width(320));
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(kUI_Width(175));
            make.top.equalTo(kUI_Width(20));
            make.height.equalTo(kUI_Width(22));
            make.centerX.equalTo(0);
        }];
        [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(20));
            make.height.equalTo(kUI_Width(17));
//            make.width.equalTo(kUI_Width(60));
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kUI_Width(20));
        }];
        [self.protocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(kUI_Width(17));
//            make.width.equalTo(kUI_Width(72));
            make.left.equalTo(kUI_Width(20));
            make.top.mas_equalTo(self.subTitleLabel.mas_bottom).offset(kUI_Width(8));
        }];
//        [self.protocolLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        UITapGestureRecognizer *protocolTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(protocolDidiClicked)];
        [self.protocolLabel addGestureRecognizer:protocolTap];
        [self.andLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.protocolLabel.mas_centerY);
            make.height.mas_equalTo(self.protocolLabel.mas_height);
            make.left.mas_equalTo(self.protocolLabel.mas_right);
//            make.width.equalTo(kUI_Width(12));
        }];
        [self.policyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.protocolLabel.mas_centerY);
            make.height.mas_equalTo(self.protocolLabel.mas_height);
            make.left.mas_equalTo(self.andLabel.mas_right);
//            make.width.equalTo(kUI_Width(72));
        }];
        UITapGestureRecognizer *policyTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(policyDidClicked)];
        [self.policyLabel addGestureRecognizer:policyTap];
        
        [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.bottom.equalTo(0);
            make.height.equalTo(kUI_Width(46));
            
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(20));
            make.right.equalTo(-kUI_Width(20));
            make.height.equalTo(kUI_Width(1));
           
            make.bottom.mas_equalTo(self.doneButton.mas_top);
        }];
        NSMutableAttributedString *att =  [[NSMutableAttributedString alloc]initWithString:@"欢迎使用来电！WY来电APP（简称“我们”）深知个人信息对您的重要性，我们将按照法律法规的规定，保护您的个人信息及隐私安全。我们制定本“隐私政策”并特别提示：希望您在使用来电及相关服务前仔细阅读并理解本隐私政策，以便做出适当的选择。本隐私政策将帮助你了解：\n 1·我们会遵循隐私政策收集、使用您的信息，但不会仅因您同意本隐私政策而采用强制捆绑的方式收集个人信息。\n 2·当您使用或开启相关功能或使用服务时，为实现功能、服务所必需，我们会收集、使用相关信息。除非是为实现基本业务功能或根据法律法规要求所必需的必要信息，您均可以拒绝提供且不影响其他功能或服务。我们将在隐私政策中逐项说明哪些是必要信息。\n 3·如果您未登录帐号，我们会通过设备对应的标识符信息来保障信息推送的基本功能。如果您登录了账号，我们会根据账号信息实现信息推送。\n 4·精确地理位置、摄像头、麦克风、相册权限，均不会默认开启，只有经过您的明示授权才会在为实现特定功能或服务时使用，您也可以撤回授权。特别需要指出的是，即使经过您的授权，我们获得了这些敏感权限，也不会在相关功能或服务不需要时而收集您的信息。\n 5·本隐私政策适用于您通过来电应用程序、来电网页、供第三方网站和应用程序使用的来电软件开发工具包（SDK）和应用程序编程接口（API）方式来访问和使用我们的产品和服务。" attributes:@{NSFontAttributeName :RegularFont(12),NSForegroundColorAttributeName:Color(@"#000000")}];
         NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
           
           paragraphStyle.lineSpacing = 5;// 行间距
           
           paragraphStyle.alignment = NSTextAlignmentLeft;// 对齐方式
          
           
//           paragraphStyle.paragraphSpacing = 5;// 段落间距
          
           

           paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;// 分割模式
        [att addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, att.length)];
        self.textView.attributedText = att;
        [self.textView setScrollsToTop:YES];
         [self.textView setContentOffset:CGPointZero];
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(20) - self.textView.contentInset.left);
            make.right.equalTo(-(kUI_Width(20) - self.textView.contentInset.right));
            make.top.mas_equalTo(self.protocolLabel.mas_bottom).offset(kUI_Width(8) - self.textView.contentInset.top - 10);
//            make.height.equalTo(kUI_Width(157));
             make.bottom.mas_equalTo(self.lineView.mas_top);
        }];
        [self.shelterView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(kUI_Width(20));
            make.left.equalTo(kUI_Width(20));
                       make.right.equalTo(-kUI_Width(20));
            make.bottom.mas_equalTo(self.lineView.mas_top);
        }];
        
        
        
        
        
    }
    return self;
}
- (void)protocolDidiClicked{
    if (self.protocolClicked) {
        self.protocolClicked(1);
//        [LCLocalDataTools saveLoacalDataWithKey:protocolSavePath object:@(YES) catheType:LCLocalDataToolsSaveType_Library];
        [self dismiss];
    }
}
- (void)policyDidClicked{
    if (self.protocolClicked) {
        self.protocolClicked(2);
//        [LCLocalDataTools saveLoacalDataWithKey:protocolSavePath object:@(YES) catheType:LCLocalDataToolsSaveType_Library];
//       
        [self dismiss];
    }
}
- (void)doneButtonClicked:(UIButton *)btn{
    [LCLocalDataTools saveLoacalDataWithKey:protocolSavePath object:@(YES) catheType:LCLocalDataToolsSaveType_Library];
   
    [self dismiss];
}
- (void)show
{
    [self makeKeyAndVisible];
    self.hidden = NO;
}
 
- (void)dismiss
{
//     [[NSNotificationCenter defaultCenter]postNotificationName:kLDProtocolCloseNoti object:nil];
    self.hidden = YES;
    [self resignKeyWindow];
    
}
#pragma mark----懒加载----
- (UIView *)contentView{
    if (_contentView == nil) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        _contentView = view;
        _contentView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _contentView.layer.cornerRadius = kUI_Width(14);
        _contentView.clipsToBounds = YES;
        [self addSubview:_contentView];
    }
    return _contentView;
}
- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLabel  = label;
        _titleLabel.font = BoldFont(16);
        _titleLabel.textColor = [UIColor colorWithHexString:@"#000000"];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _titleLabel.text = @"个人信息保护引导";
        [self.contentView addSubview:_titleLabel];
        
    }
    return _titleLabel;
}
- (UILabel *)subTitleLabel{
    if (_subTitleLabel == nil) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        _subTitleLabel  = label;
        _subTitleLabel.font = BoldFont(12);
        _subTitleLabel.textColor = [UIColor colorWithHexString:@"#000000"];
//        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        _subTitleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _subTitleLabel.text = @" 请充分理解";
        [self.contentView addSubview:_subTitleLabel];
    }
    return _subTitleLabel;
}
- (UILabel *)protocolLabel{
    if (_protocolLabel == nil) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        _protocolLabel  = label;
        _protocolLabel.font = BoldFont(12);
        _protocolLabel.textColor = [UIColor colorWithHexString:@"#0051C6"];
//        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        _protocolLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _protocolLabel.text = @"《用户协议》";
        _protocolLabel.userInteractionEnabled = YES;
        [self.contentView addSubview:_protocolLabel];
    }
    return _protocolLabel;
}
- (UILabel *)andLabel{
    if (_andLabel == nil) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
            _andLabel  = label;
            _andLabel.font = BoldFont(12);
            _andLabel.textColor = [UIColor colorWithHexString:@"#000000"];
    //        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
            _andLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _andLabel.text = @"和";
            [self.contentView addSubview:_andLabel];
        }
        return _andLabel;
}
- (UILabel *)policyLabel{
    if (_policyLabel == nil) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        _policyLabel  = label;
        _policyLabel.font = BoldFont(12);
        _policyLabel.textColor = [UIColor colorWithHexString:@"#0051C6"];
//        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        _policyLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _policyLabel.text = @"《隐私政策》";
        _policyLabel.userInteractionEnabled = YES;
        [self.contentView addSubview:_policyLabel];
    }
    return _policyLabel;
}
- (UITextView *)textView{
    if (_textView == nil) {
        UITextView *view = [[UITextView alloc]initWithFrame:CGRectZero];
        _textView = view;
        _textView.editable = NO;
        _textView.font = RegularFont(12);
        _textView.textColor = [UIColor colorWithHexString:@"#000000"];
        if (@available
        (iOS
        11.0, *)) {
            _textView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;

           
        }
       
        [self.contentView addSubview:_textView];
    }
    return _textView;
}
- (LCShelterGradientView *)shelterView{
    if (_shelterView == nil) {
     LCShelterGradientView *topView = [[LCShelterGradientView alloc]initWithFrame:CGRectZero];
           
       topView.gradientLayer.startPoint =CGPointMake(0.5, 0);
       topView.gradientLayer.endPoint = CGPointMake(0.5, 1);
       topView.gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#FFFFFF" alpha:0].CGColor, (__bridge id)[UIColor colorWithHexString:@"#FFFFFF" alpha:1].CGColor];
      topView.gradientLayer.locations = @[@(0), @(1.0f)];
        _shelterView = topView;
        [self.contentView addSubview:topView];
    }
    return _shelterView;
}
- (UIView *)lineView{
    if (_lineView == nil) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        _lineView = view;
        _lineView.backgroundColor = Color(@"#DCDCDC");
        [self.contentView addSubview:_lineView];
    }
    return _lineView;
}
- (UIButton *)doneButton{
    if (_doneButton == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _doneButton = btn;
        [_doneButton setTitle:@"我知道了" forState:UIControlStateNormal];
        _doneButton.titleLabel.font = BoldFont(16);
        [_doneButton setTitleColor:Color(@"#3C3C3C") forState:UIControlStateNormal];
        [self.contentView addSubview:_doneButton];
        [_doneButton addTarget:self action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneButton;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
