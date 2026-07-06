//
//  LCSinglePickView.m
//  LCHeadlines
//
//  Created by mrgao on 2020/10/23.
//  Copyright © 2020 WY. All rights reserved.
//

#import "LCSinglePickView.h"

@interface LCSinglePickView ()<UIPickerViewDelegate,UIPickerViewDataSource,UIGestureRecognizerDelegate>
@property(nonatomic, weak) UIView *contentView;
@property(nonatomic, weak) UIButton *leftButton;
@property(nonatomic, weak) UIButton *rightButton;

@property(nonatomic, weak) UIPickerView *pickerView;

@property(nonatomic, assign) NSInteger selectIndex;

@end
@implementation LCSinglePickView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.selectIndex = 0;
        self.backgroundColor =  [UIColor colorWithHexString:@"#000000" alpha:0.7];

        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        _contentView = view;
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
        
        
       
        UIButton *canBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [canBtn setTitle:@"取消" forState:UIControlStateNormal];
        [canBtn addTarget:self action:@selector(leftButtonWithButton) forControlEvents:UIControlEventTouchUpInside];
        
        self.leftButton = canBtn;
        self.leftButton.titleLabel.font = RegularFont(14);
        [self.leftButton setTitleColor:[UIColor colorWithHexString:@"#3C3C3C"] forState:(UIControlStateNormal)];
        self.leftButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.leftButton setEnlargeEdgeWithTop:kUI_Width(15) right:kUI_Width(15) bottom:kUI_Width(15) left:kUI_Width(15)];
        [self.contentView addSubview:self.leftButton];

        UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sureBtn setTitle:@"完成" forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(rightButtonWithButton:) forControlEvents:UIControlEventTouchUpInside];
      
        self.rightButton  =sureBtn;
        self.rightButton.titleLabel.font = RegularFont(14);
        [self.rightButton setTitleColor:[UIColor colorWithHexString:@"#3C3C3C"] forState:(UIControlStateNormal)];
        self.rightButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [self.rightButton setEnlargeEdgeWithTop:kUI_Width(15) right:kUI_Width(15) bottom:kUI_Width(15) left:kUI_Width(15)];
        [self.contentView addSubview:self.rightButton];
        
        

        UIPickerView *pick = [[UIPickerView alloc] initWithFrame:CGRectZero];
        self.pickerView = pick;
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        [self.contentView addSubview:self.pickerView];
       
        
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(0);
            make.height.equalTo(kUI_Width(320));
        }];

        [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(kUI_Width(15));
            make.left.equalTo(kUI_Width(10));
            make.width.equalTo(kUI_Width(65));
            make.height.equalTo(kUI_Width(30));
        }];
        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(kUI_Width(15));
            make.right.equalTo(-kUI_Width(10));
            make.width.equalTo(kUI_Width(65));
            make.height.equalTo(kUI_Width(30));
        }];
        [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(kUI_Width(30));
            make.right.equalTo(0);
            make.left.equalTo(0);
            make.bottom.equalTo(-kUI_Width(30));
        }];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftButtonWithButton)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];

    }
    return self;
}
- (void)leftButtonWithButton{
    [self removeFromSuperview];
}

- (void)rightButtonWithButton:(UIButton *)button {
    if (!(self.titleArr.count  )) {
        return;
    }
    if (self.selectBlock) {
        self.selectBlock(self.titleArr[self.selectIndex], self.selectIndex);
    }
    [self removeFromSuperview];
}
- (void)setTitleArr:(NSArray *)titleArr{
    _titleArr = [titleArr copy];
    [self.pickerView reloadAllComponents];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:self.contentView]) {
    
        return NO;
    }
    
    return YES;
}
//UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件包含的列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {

    return 1;
}

//UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件指定列包含多少个列表项
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.titleArr.count;
}

// UIPickerViewDelegate中定义的方法，该方法返回的NSString将作为UIPickerView
// 中指定列和列表项的标题文本
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.titleArr[row];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectIndex = row;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
@end
