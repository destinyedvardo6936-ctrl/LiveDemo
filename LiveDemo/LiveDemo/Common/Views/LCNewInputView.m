//
//  LCNewInputView.m
//  LCHeadlines
//
//  Created by mrgao on 2020/10/12.
//  Copyright © 2020 WY. All rights reserved.
//

#import "LCNewInputView.h"
#import "UITextView+LCPlaceHolder.h"
#import <IQKeyboardManager.h>

@interface LCNewInputView ()<UITextViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic,weak)UIView *bottomView;
@property (nonatomic,weak)UILabel *titleLabel;
@property (nonatomic,weak)UIButton *backBtn;
@property (nonatomic,weak)UIButton *doneButton;
@property (nonatomic,weak)UIView *textBackView;
@property (nonatomic,weak)UITextView *textView;

@property (nonatomic,assign)CGFloat keyBoardheight;

@end
@implementation LCNewInputView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
//        [IQKeyboardManager sharedManager].enable = YES;
              [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
             
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.bottom.equalTo(0);
            make.height.equalTo(kUI_Width(138));
        }];
        [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
         
               make.right.equalTo(-kUI_Width(kViewMargin));
               make.width.equalTo(kUI_Width(30));
               make.height.equalTo(kUI_Width(20));
               make.top.equalTo(kUI_Width(20));
           }];
        [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(kViewMargin));
            make.width.height.equalTo(kUI_Width(24));
            make.centerY.mas_equalTo(self.doneButton.mas_centerY);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.height.equalTo(kUI_Width(20));
            make.centerY.mas_equalTo(self.doneButton.mas_centerY);
        }];
       
        [self.textBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(kViewMargin));
            make.right.equalTo(-kUI_Width(kViewMargin));
            make.height.equalTo(kUI_Width(76));
            make.top.mas_equalTo(self.doneButton.mas_bottom).offset(kUI_Width(15));
        }];
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(kUI_Width(8) );
            make.left.equalTo(kUI_Width(14));
            make.right.equalTo(-kUI_Width(14));
            make.bottom.equalTo(-kUI_Width(8) );
        }];
//        UITextInputAssistantItem* item = [self.textView inputAssistantItem];
//        item.leadingBarButtonGroups = @[];
//        item.trailingBarButtonGroups = @[];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelSender)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        //注册键盘监听事件
               [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//               [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidShow) name:UIKeyboardDidShowNotification object:nil];
               [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillhiden:) name:UIKeyboardWillHideNotification object:nil];
               [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidhiden) name:UIKeyboardDidHideNotification object:nil];
       
        
    }
    return self;
}
- (void)showKeyBoard{
     [self.textView becomeFirstResponder];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isDescendantOfView:self.bottomView]) {
        
        
        return NO;
    }
    if ([touch locationInView:self].y > self.bottomView.top - kUI_Width(10)) {
        return NO;
    }
    return YES;
}
//确认发送
- (void)btnClickSender {
    [self.textView resignFirstResponder];
    if (self.sendBlock) {
        self.sendBlock(self.textView.text);
    }
    [self removeFromSuperview];
}
- (void)cancelSender {
    [self.textView resignFirstResponder];
    

    [self removeFromSuperview];

}
- (void)keyBoardWillShow:(NSNotification *)notification {
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
        return;
    }
   

    NSDictionary *info = [notification userInfo];
   

    NSValue *value = info[UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    // 获取键盘动画时间
    CGFloat animationTime  = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:animationTime animations:^{
        self.bottomView.transform = CGAffineTransformMakeTranslation(0, -keyboardSize.height);
    }];
    _keyBoardheight = keyboardSize.height;
    if ([self.textView isFirstResponder]) {

      
        [self setTextFrameWithKeyBoardHeight:keyboardSize.height];
       

    }
}
- (void)setTextFrameWithKeyBoardHeight:(CGFloat)keyboardHeight {
    //动态修改输入框高度，
    
    CGFloat height = [self.textView sizeThatFits:CGSizeMake(self.textView.width, CGFLOAT_MAX)].height;
    
    if (height < kUI_Width(76) - kUI_Width(8) - kUI_Width(8) ) {
       
            
            [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(kUI_Width(76) - kUI_Width(8) - kUI_Width(8) );
            }];
            [self.textBackView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(kUI_Width(76));
            }];
            [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                 make.height.equalTo(kUI_Width(138));
            }];
             
        }else{
           
            [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(height );
            }];
            [self.textBackView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(height + kUI_Width(8)*2 );
            }];
            [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                 make.height.equalTo( height + kUI_Width(8)*2 + kUI_Width(15) + kUI_Width(20) + kUI_Width(20) + kUI_Width(16));
            }];
             
        }
        
       
    
   
    
}


- (void)keyBoardWillhiden:(NSNotification *)notification {
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
        return;
    }
    // 获取用户信息
       NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:notification.userInfo];
       // 获取键盘动画时间
       CGFloat animationTime  = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
       
      
       
     
           [UIView animateWithDuration:animationTime animations:^{
               self.bottomView.transform = CGAffineTransformIdentity;
           }];
       

}

- (void)keyBoardDidhiden{
  self.backgroundColor = [UIColor clearColor];
    [IQKeyboardManager sharedManager].enable = NO;
    [self removeFromSuperview];
    
}
#pragma mark UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
   
   

    
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 200) {
        textView.text = [textView.text substringToIndex:200];
    }

   
    [self setTextFrameWithKeyBoardHeight:_keyBoardheight];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
   
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    

    //点击完成按钮
    if ([text isEqualToString:@"\n"]) {
        if (!self.textView.text.length) {
            [SVProgressHUD showErrorWithStatus:KLanguage(@"说点什么吧")];
            return NO;
        }
        [self.textView resignFirstResponder];
        if (self.sendBlock) {
            self.sendBlock(self.textView.text);
        }
        [self removeFromSuperview];
//        [self btnClickSender];
        return NO;
    }
    if ([text isEqualToString:@""]) {
        return YES;
    }
    if (range.location > 200) {
        return NO;
    }

    if (self.textView.text.length >= 200) {

        return NO;
    }

    return YES;
}
- (void)setPlaceHolderText:(NSString *)placeHolderText{
    _placeHolderText = placeHolderText;
    if (_placeHolderText.length) {
         NSAttributedString *att = [[NSAttributedString alloc]initWithString:_placeHolderText attributes:@{NSFontAttributeName:RegularFont(15),NSForegroundColorAttributeName:Color(@"#CED1DD")}];
         self.textView.attributedPlaceholder = att;
    }else{
        NSAttributedString *att = [[NSAttributedString alloc]initWithString:@"说点什么吧" attributes:@{NSFontAttributeName:RegularFont(15),NSForegroundColorAttributeName:Color(@"#CED1DD")}];
        self.textView.attributedPlaceholder = att;
    }
}

#pragma mark----懒加载----
- (UIView *)bottomView{
    if (_bottomView == nil) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        _bottomView = view;
        _bottomView.backgroundColor = Color(@"#FFFFFF");
        _bottomView.layer.shadowOffset = CGSizeMake(0,-1);
        _bottomView.layer.shadowOpacity = 1;
        _bottomView.layer.shadowRadius = 0;
        _bottomView.layer.shadowColor = Color(@"#F4F6FB").CGColor;
        
        [self addSubview:_bottomView];
    }
    return _bottomView;
}
- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLabel = label;
        _titleLabel.font = RegularFont(15);
        _titleLabel.textColor = Color(@"#9193A0");
        _titleLabel.text = @"发表神评论";
        [self.bottomView addSubview:_titleLabel];
    }
    return _titleLabel;
}
- (UIButton *)backBtn{
    if (_backBtn == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn = btn;
        [_backBtn setImage:image(@"ic_inputDown") forState:UIControlStateNormal];
        [self.bottomView addSubview:_backBtn];
        [_backBtn addTarget:self action:@selector(cancelSender) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}
- (UIView *)textBackView{
    if (_textBackView == nil) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        _textBackView = view;
        _textBackView.backgroundColor = Color(@"#F4F6FB");
       
        [self.bottomView addSubview:_textBackView];
//        UIView *lineView = [[UIView alloc]initWithFrame:CGRectZero];
//        lineView.backgroundColor = Color(@"#293753);
//        [_textBackView addSubview:lineView];
//        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(kUI_Width(15));
//            make.centerY.equalTo(0);
//            make.width.equalTo(kUI_Width(1));
//            make.left.equalTo(kUI_Width(10));
//        }];
    }
    return _textBackView;
}
- (UITextView *)textView{
    if (_textView == nil) {
        UITextView *textView = [[UITextView alloc]initWithFrame:CGRectZero];
        _textView = textView;
        _textView.delegate = self;
        _textView.scrollEnabled = NO;
       _textView.returnKeyType = UIReturnKeySend;
        _textView.backgroundColor = [UIColor clearColor];
        _textView.font = RegularFont(15);
        NSAttributedString *att = [[NSAttributedString alloc]initWithString:@"说点什么吧" attributes:@{NSFontAttributeName:RegularFont(15),NSForegroundColorAttributeName:Color(@"#CED1DD")}];
        _textView.attributedPlaceholder = att;
        _textView.textContainerInset = UIEdgeInsetsZero;
        [self.textBackView addSubview:_textView];
    }
    return _textView;
}
- (UIButton *)doneButton{
    if (_doneButton == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _doneButton = btn;
        [_doneButton setTitle:@"发布" forState:UIControlStateNormal];
           [_doneButton setTitleColor:Color(@"#0064FF") forState:UIControlStateNormal];
           _doneButton.titleLabel.font = RegularFont(15);
           [_doneButton addTarget:self action:@selector(btnClickSender) forControlEvents:UIControlEventTouchUpInside];
           [self.bottomView addSubview:_doneButton];
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
