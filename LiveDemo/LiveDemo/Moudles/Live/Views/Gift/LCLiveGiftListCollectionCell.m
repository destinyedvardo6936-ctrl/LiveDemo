//
//  LCLiveGiftListCollectionCell.m
//  LiveDemo
//
//  Created by mrgao on 2023/3/13.
//

#import "LCLiveGiftListCollectionCell.h"

@interface LCLiveGiftListCollectionCell ()
@property (nonatomic , weak) UIView *backView;
@property (nonatomic , weak) UIImageView *leftTypeImgView;
@property (nonatomic , weak) UIImageView *mainImgView;
@property (nonatomic , weak) UIImageView *rightTypeImgView;

@property (nonatomic , weak) UILabel *titleLabel;
//@property (nonatomic , weak) UIImageView *tipImgView;
@property (nonatomic , weak) UILabel *valueLabel;
@end
@implementation LCLiveGiftListCollectionCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.top.bottom.equalTo(0);
            make.width.equalTo(kUI_Width(80));
        }];
        
        [self.mainImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.height.equalTo(self.mainImgView.mas_width);
           
            make.top.equalTo(0);
           
        }];
        [self.leftTypeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(0);
            make.width.equalTo(kUI_Width(30));
            make.height.equalTo(kUI_Width(13));
        }];
        [self.rightTypeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.equalTo(0);
            make.width.equalTo(kUI_Width(15));
            make.height.equalTo(kUI_Width(13));
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.height.equalTo(kUI_Width(14));
           
            make.top.mas_equalTo(self.mainImgView.mas_bottom).offset(kUI_Width(6));
           
        }];

        [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.height.equalTo(kUI_Width(14));
          
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kUI_Width(4));
           
        }];
    }
    return self;
}

- (void)setDataModel:(LCLiveGiftModel *)dataModel{
    _dataModel = dataModel;
    @weakify(self);
    if(_dataModel == nil){
        self.backView.layer.borderWidth = 0;
        self.mainImgView.image = nil;
        self.titleLabel.text = nil;
        self.valueLabel.attributedText = nil;
        return;
    }
    [[RACObserve(_dataModel, isSelected) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSNumber *  _Nullable x) {
        @strongify(self)
        if([x boolValue]){
            self.backView.layer.borderWidth = 1;
            self.backView.layer.borderColor = Color(@"#FF2159").CGColor;
            
        }else{
            self.backView.layer.borderWidth = 0;
//            self.backView.layer.borderColor = Color(@"").CGColor;
        }
    }];
    [[RACObserve(_dataModel, gifticon) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString *  _Nullable x) {
        @strongify(self)
        [self.mainImgView setImageStr:x];
    }];
    RAC(self.titleLabel,text) = [RACObserve(_dataModel, giftname) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.valueLabel,attributedText) = [[RACObserve(_dataModel, needcoin) map:^NSString * _Nullable(NSString *  _Nullable value) {
        if(!value.length){
            return nil;
        }
        NSTextAttachment *attchment = [[NSTextAttachment alloc]init];
        attchment.bounds = CGRectMake(0, 0, kUI_Width(14), kUI_Width(14));//设置frame
        attchment.image =image(@"icon_liveGiftZSImg") ;
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithAttributedString:[NSAttributedString attributedStringWithAttachment:attchment]];
        [att appendAttributedString:[[NSAttributedString alloc]initWithString:value attributes:@{NSFontAttributeName:MediumFont(14),NSForegroundColorAttributeName:Color(@"#FFFFFF")}]];
        return att.copy;
    }] takeUntil:self.rac_prepareForReuseSignal];
    [[RACObserve(_dataModel, type) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString *  _Nullable x) {
        @strongify(self)
        if(x.integerValue == 1){
            self.rightTypeImgView.hidden = NO;
            if([self.dataModel.isplatgift intValue] == 1){
                self.rightTypeImgView.image = image(@"icon_liveGiftAllImg");
            }else{
                self.rightTypeImgView.image = image(@"icon_liveGiftTHImg");
            }
        }else {
            self.rightTypeImgView.hidden = YES;
        }
    }];
    [[RACObserve(_dataModel, mark) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString *  _Nullable x) {
        @strongify(self)
        if(x.integerValue == 1){
            self.leftTypeImgView.image = image(@"icon_liveGiftHotImg");
        }else if (x.integerValue == 2){
            self.leftTypeImgView.image = image(@"icon_liveGiftGuardImg");
        }else{
            self.leftTypeImgView.image = nil;
        }
    }];
   
}
#pragma mark---- 懒加载 ----
- (UIView *)backView{
    if(!_backView){
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor clearColor];
        view.layer.cornerRadius = kUI_Width(4);
        view.clipsToBounds = YES;
        [self.contentView addSubview:view];
        _backView = view;
    }
    return _backView;
}
- (UIImageView *)mainImgView {
    if (_mainImgView == nil) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _mainImgView = imgView;
        _mainImgView.contentMode = UIViewContentModeScaleAspectFit;
    
//        _mainImgView.layer.masksToBounds = YES;
//        _mainImgView.clipsToBounds = YES;
        [self.backView addSubview:_mainImgView];
    }

    return _mainImgView;
}
- (UIImageView *)leftTypeImgView {
    if (_leftTypeImgView == nil) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _leftTypeImgView = imgView;
        _leftTypeImgView.contentMode = UIViewContentModeScaleAspectFit;
    
//        _mainImgView.layer.masksToBounds = YES;
//        _mainImgView.clipsToBounds = YES;
        [self.backView addSubview:_leftTypeImgView];
    }

    return _leftTypeImgView;
}
- (UIImageView *)rightTypeImgView {
    if (_rightTypeImgView == nil) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _rightTypeImgView = imgView;
        _rightTypeImgView.contentMode = UIViewContentModeScaleAspectFit;
    
//        _mainImgView.layer.masksToBounds = YES;
//        _mainImgView.clipsToBounds = YES;
        [self.backView addSubview:_rightTypeImgView];
    }

    return _rightTypeImgView;
}
- (UILabel *)titleLabel{
    if(_titleLabel == nil){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
       
        label.font = MediumFont(14);
        label.textColor = Color(@"#FFFFFF");
        label.textAlignment = NSTextAlignmentCenter;
 
        [self.backView addSubview:label];
//        [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
//        [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        _titleLabel = label;
    }
    return _titleLabel;
}
//- (UIImageView *)tipImgView{
//    if(!_tipImgView){
//        UIImageView *imgView = [[UIImageView alloc] initWithImage:image(@"icon_liveGiftZSImg")];
//        _tipImgView = imgView;
//
//        [self.contentView addSubview:_tipImgView];
//    }
//    return _tipImgView;
//}
- (UILabel *)valueLabel{
    if(_valueLabel == nil){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
       
        label.font = MediumFont(14);
        label.textColor = Color(@"#FFFFFF");
        label.textAlignment = NSTextAlignmentCenter;
 
        [self.backView addSubview:label];
        [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        _valueLabel = label;
    }
    return _valueLabel;
}




@end
