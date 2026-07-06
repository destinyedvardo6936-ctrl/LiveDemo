//
//  RKActionSheet.m
//  iphoneLive
//
//  Created by YB007 on 2020/7/2.
//  Copyright © 2020 cat. All rights reserved.
//

#import "RKActionSheet.h"

#define sheetHeight 50

@interface RKSheetBtn : UIButton
@property(nonatomic,assign)RKSheetType sheetType;
@property(nonatomic,copy)RKSheetBlock sheetBtnBlock;

@end
@implementation RKSheetBtn

@end

@interface RKActionSheet()<UIGestureRecognizerDelegate>

@property(nonatomic,strong)MASViewAttribute *nextMaViewTop;
@property(nonatomic,strong)NSString *titleStr;                      //标题
@property(nonatomic,strong)UILabel *titleL;                         //标题 label
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIView *exceptCancelView;                //除了except 取消按钮(RKSheet_Cancle)外的所有空间
@property(nonatomic,strong)RKSheetBtn *cancelBtn;                   //取消按钮
@property(nonatomic,strong)NSMutableArray *exceptCancelMutArray;    //除了取消按钮外数组

@end

@implementation RKActionSheet

- (instancetype)initWithTitle:(NSString *)titleStr{
    self = [super init];
    if (self) {
        _titleStr = titleStr;
        [self createUI];
    }
    return self;
}

-(void)createUI {
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.backgroundColor = ColorAlpha(@"#000000", 0.3);
    self.exceptCancelMutArray = [NSMutableArray array];
    
    [self addSubview:self.bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-KSafeHeight-10);
        make.width.equalTo(self.mas_width).multipliedBy(0.9);
        make.centerX.equalTo(self);
    }];
    
    [_bgView addSubview:self.exceptCancelView];
    
    _nextMaViewTop = _exceptCancelView.mas_top;
//    [[UIApplication sharedApplication].delegate.window addSubview:self];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissView)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    if (![NSString checkNull:_titleStr]) {
        [_exceptCancelView addSubview:self.titleL];
        [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_exceptCancelView);
            make.top.equalTo(_exceptCancelView.mas_top).offset(10);
        }];
        UILabel *titleLineL = [[UILabel alloc]init];
        titleLineL.backgroundColor = ColorAlpha(@"#969696", 0.8);
        [_exceptCancelView addSubview:titleLineL];
        [titleLineL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.centerX.equalTo(_exceptCancelView);
            make.height.mas_equalTo(0.5);
            make.top.equalTo(_titleL.mas_bottom).offset(18);
        }];
        _nextMaViewTop = titleLineL.mas_bottom;
    }
    
}
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = UIColor.clearColor;
    }
    return _bgView;
}
- (UIView *)exceptCancelView{
    if (!_exceptCancelView) {
        _exceptCancelView = [[UIView alloc]init];
        _exceptCancelView.backgroundColor = [UIColor whiteColor];
        _exceptCancelView.layer.cornerRadius = 10;
        _exceptCancelView.layer.masksToBounds = YES;
    }
    return _exceptCancelView;
}

- (UILabel *)titleL {
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.text = _titleStr;
        _titleL.font = RegularFont(13);
        _titleL.textColor = ColorAlpha(@"#969696", 1);
    }
    return _titleL;
}
-(void)addLineOfTop:(RKSheetBtn *)btn {
    UILabel *lineL = [[UILabel alloc]init];
    lineL.backgroundColor = ColorAlpha(@"#969696", 0.8);
    [_exceptCancelView addSubview:lineL];
    [lineL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.centerX.equalTo(_exceptCancelView);
        make.height.mas_equalTo(0.5);
        make.bottom.equalTo(btn.mas_top);
    }];
}
-(void)dismissView {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self removeFromSuperview];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;{
    if ([touch.view isDescendantOfView:self.bgView]) {
        return NO;
    }
    return YES;
}

-(void)addActionWithType:(RKSheetType)sheetType andTitle:(NSString *)titile complete:(RKSheetBlock)complete {
    RKSheetBtn *btn = [RKSheetBtn buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = RegularFont(15);
    [btn setTitle:titile forState:0];
    btn.sheetBtnBlock = complete;
    btn.sheetType = sheetType;
    [btn addTarget:self action:@selector(clickActionBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    //这里根据 RKSheetType 来显示 btn 标题颜色 可自行扩展结构体
    switch (sheetType) {
        case RKSheet_Cancle:
            [btn setTitleColor:ColorAlpha(@"#969696", 1) forState:0];
            break;
        case RKSheet_Default:
            [btn setTitleColor:ColorAlpha(@"#323232", 1) forState:0];
            break;
        case RKSheet_FunPink:
            [btn setTitleColor:[UIColor colorWithRed:255/255.0 green:88/255.0 blue:120/255.0 alpha:1] forState:0];
        default:
            break;
    }
    if (btn.sheetType != RKSheet_Cancle) {
        [_exceptCancelMutArray addObject:btn];
        [_exceptCancelView addSubview:btn];
    }else{
        btn.layer.cornerRadius = _exceptCancelView.layer.cornerRadius;
        btn.layer.masksToBounds = YES;
        _cancelBtn = btn;
        _cancelBtn.backgroundColor = _exceptCancelView.backgroundColor;
        [_bgView addSubview:_cancelBtn];
    }
    
}

-(void)clickActionBtn:(RKSheetBtn*)sender {
    
    if (sender.sheetBtnBlock) {
        sender.sheetBtnBlock();
    }
    [self dismissView];
}


-(void)showSheet {
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    //取消按钮
    if (_cancelBtn) {
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_bgView.mas_bottom);
            make.centerX.width.equalTo(_exceptCancelView);
            make.height.mas_equalTo(sheetHeight);
        }];
        [_exceptCancelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_cancelBtn.mas_top).offset(-10);
            make.width.centerX.equalTo(_bgView);
            make.top.equalTo(_bgView.mas_top);
        }];
    }else{
        [_exceptCancelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_bgView.mas_bottom);
            make.width.centerX.equalTo(_bgView);
            make.top.equalTo(_bgView.mas_top);
        }];
    }
    
    //除去取消按钮外其他按钮
    MASViewAttribute *bottomeMas = _exceptCancelView.mas_bottom;
    for (int i = ((int)_exceptCancelMutArray.count-1); i >= 0; i--) {
        RKSheetBtn *btn = _exceptCancelMutArray[i];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(bottomeMas).offset(-0.5);
            make.centerX.width.equalTo(_exceptCancelView);
            make.height.mas_equalTo(sheetHeight);
            if (i == 0) {
                make.top.equalTo(_nextMaViewTop).offset(0.5);
            }
        }];
        if (i > 0 ) {
            [self addLineOfTop:btn];
        }
        bottomeMas = btn.mas_top;
    }
    

}


@end
