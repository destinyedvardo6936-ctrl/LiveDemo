//
//  LCWithDrawAccountTableViewCell.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/23.
//

#import "LCWithDrawAccountTableViewCell.h"

@interface LCWithDrawAccountTableViewCell ()
@property (nonatomic , weak) UIView *backView;
@property (nonatomic , weak) UIImageView *paymentImgView;
@property (nonatomic , weak) UILabel *paymentLabel;
@property (nonatomic , weak) UIButton *selectBtn;
@property (nonatomic , weak) UIView *lineView;
@property (nonatomic , weak) UILabel *accountLabel;
@end
@implementation LCWithDrawAccountTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(16));
            make.right.equalTo(-kUI_Width(16));
            make.top.equalTo(0);
            make.bottom.equalTo(0);
            
        }];
        [self.paymentImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.top.equalTo(kUI_Width(10));
            make.width.height.equalTo(kUI_Width(16));
        }];
        [self.paymentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.paymentImgView.mas_centerY);
            make.height.equalTo(kUI_Width(12));
            make.left.mas_equalTo(self.paymentImgView.mas_right).offset(kUI_Width(10));
        }];
        [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(kUI_Width(12));
            make.right.equalTo(-kUI_Width(10));
            make.centerY.mas_equalTo(self.paymentImgView.mas_centerY);
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(kUI_Width(36));
            make.left.right.equalTo(0);
            make.height.equalTo(1);
        }];
        [self.accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(-kUI_Width(12));
            make.left.equalTo(kUI_Width(12));
            make.height.equalTo(kUI_Width(12));
            make.right.equalTo(-kUI_Width(12));
        }];
    }
    return self;
}
- (void)setDataModel:(LCWithDrawAccountModel *)dataModel{
    _dataModel = dataModel;
    @weakify(self);
    [[RACObserve(_dataModel, type) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString *  _Nullable x) {
        @strongify(self)
        if([x isEqualToString:@"1"]){
            self.paymentImgView.image = image(@"icon_zfbImg");
            self.paymentLabel.text = self.dataModel.name;
        }else if ([x isEqualToString:@"2"]){
            self.paymentImgView.image = image(@"icon_utsd");
            self.paymentLabel.text = self.dataModel.name;
        }else if ([x isEqualToString:@"3"]){
            self.paymentImgView.image = image(@"icon_bankImg");
            self.paymentLabel.text = self.dataModel.name;
        }
    }];
    [[RACObserve(_dataModel, modelId) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString *  _Nullable x) {
        @strongify(self)
        if(x.length){
            UILabel *label = [self.selectBtn viewWithTag:200];
            label.text = KLanguage(@"修改");
        }else{
            UILabel *label = [self.selectBtn viewWithTag:200];
            label.text = KLanguage(@"添加");
        }
    }];
    
    [[RACObserve(_dataModel, account)  takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString *  _Nullable x) {
        @strongify(self)
        NSString *typeName = nil;
        if([self.dataModel.type isEqualToString:@"1"]){
           typeName = KLanguage(@"支付宝");
        }else if ([self.dataModel.type isEqualToString:@"2"]){
            typeName = KLanguage(@"地址");
        }else if ([self.dataModel.type isEqualToString:@"3"]){
            typeName = KLanguage(@"银行卡");
        }
        if(!x){
            self.accountLabel.text = [NSString stringWithFormat:@"%@%@：%@",typeName,KLanguage(@"账号"),KLanguage(@"暂无")];
            
        }else{
            self.accountLabel.text = [NSString stringWithFormat:@"%@%@：%@",typeName,KLanguage(@"账号"),x];
        }
        
    }] ;
}
#pragma mark---- 懒加载 ----
- (UIView *)backView{
    if(!_backView){
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.layer.borderWidth = 1;
        view.layer.borderColor = Color(@"#FFD2DC").CGColor;
        view.layer.cornerRadius = kUI_Width(4);
        [self.contentView addSubview:view];
        _backView = view;
    }
    return _backView;
}
- (UIImageView *)paymentImgView{
    if(!_paymentImgView){
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        [self.backView addSubview:imgView];
        _paymentImgView = imgView;
    }
    return _paymentImgView;
}
- (UILabel *)paymentLabel{
    if(!_paymentLabel){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = RegularFont(12);
        label.textColor = Color(@"#333333");
//        label.text = @"¥";
        [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.backView addSubview:label];
        _paymentLabel = label;
    }
    return _paymentLabel;
}
- (UIButton *)selectBtn{
    if(!_selectBtn){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
       
        [self.backView addSubview:btn];
       
        _selectBtn = btn;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = RegularFont(12);
        label.textColor = Color(@"#EF4B51");
        [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        label.text = KLanguage(@"添加");
        label.tag = 200;
        [_selectBtn addSubview:label];
        UIImageView *imgView = [[UIImageView alloc]initWithImage:image(@"icon_withDrawAccountAccessImg")];
        [_selectBtn addSubview:imgView];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.height.equalTo(kUI_Width(12));
            make.centerY.equalTo(0);
        }];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(0);
            make.left.mas_equalTo(label.mas_right).offset(kUI_Width(2));
            make.width.height.equalTo(kUI_Width(10));
            make.centerY.equalTo(0);
        }];
        WS(weakSelf)
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [weakSelf.clickSubject sendNext:weakSelf.dataModel];
        }];
    }
    return _selectBtn;
}
- (UIView *)lineView{
    if(_lineView == nil){
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
       

        view.backgroundColor = Color(@"#FFD2DC");
        [self.backView addSubview:view];
        _lineView = view;
    }
    return _lineView;
}
- (UILabel *)accountLabel{
    if(!_accountLabel){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = RegularFont(12);
        label.textColor = Color(@"#333333");
//        label.text = @"¥";
        [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.backView addSubview:label];
        _accountLabel = label;
    }
    return _accountLabel;
}
- (RACSubject *)clickSubject{
    if(!_clickSubject){
        _clickSubject = [RACSubject subject];
    }
    return _clickSubject;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end
