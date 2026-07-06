//
//  LCRechargeRecordTableCell.m
//  LiveDemo
//
//  Created by mrgao on 2023/6/8.
//

#import "LCRechargeRecordTableCell.h"

@interface LCRechargeRecordTableCell ()
@property (nonatomic , weak) UIView *backView;
@property (nonatomic , weak) UILabel *titleLabel;
@property (nonatomic , weak) UILabel *payTypeLabel;
@property (nonatomic , weak) UILabel *orderLabel;

@property (nonatomic , weak) UILabel *statusLabel;
@property (nonatomic , weak) UILabel *timeLabel;
@end
@implementation LCRechargeRecordTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.right.equalTo(-kUI_Width(12));
            make.top.equalTo(0);
            make.bottom.equalTo(0);
//            make.height.equalTo(kUI_Width(80));
        }];
       
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.height.equalTo(kUI_Width(14));
            make.right.mas_equalTo(self.statusLabel.mas_left).offset(-kUI_Width(10));
            make.top.equalTo(kUI_Width(12));
           
        }];
        [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-kUI_Width(12));
            make.height.equalTo(kUI_Width(12));
       
            make.centerY.mas_equalTo(self.titleLabel.mas_centerY);
        }];
        [self.payTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kUI_Width(10));
            make.height.equalTo(kUI_Width(12));
            make.right.equalTo(-kUI_Width(12));
        }];
        [self.orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.top.mas_equalTo(self.payTypeLabel.mas_bottom).offset(kUI_Width(10));
            make.height.equalTo(kUI_Width(12));
            make.right.equalTo(-kUI_Width(12));
        }];
        
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.top.mas_equalTo(self.orderLabel.mas_bottom).offset(kUI_Width(10));
            make.height.equalTo(kUI_Width(12));
            make.right.equalTo(-kUI_Width(12));
            make.bottom.equalTo(-kUI_Width(12));
        }];
      
        
    }
    return self;
}
- (void)setDataModel:(LCRechargeRecordModel *)dataModel{
    _dataModel = dataModel;
    @weakify(self)
    RAC(self.titleLabel,text) = [[RACObserve(_dataModel, money) map:^NSString * _Nullable(NSString *  _Nullable value) {
        if(!value){
            return nil;
        }
        return [NSString stringWithFormat:@"%@:%@%@",KLanguage(@"充值钻石"),value,KLanguage(@"钻石")];
    }] takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.orderLabel,text) = [[RACObserve(_dataModel, orderno) map:^NSString * _Nullable(NSString *  _Nullable value) {
        if(!value){
            return nil;
        }
        return [NSString stringWithFormat:@"%@:%@",KLanguage(@"订单号"),value];
    }] takeUntil:self.rac_prepareForReuseSignal];
    [[RACObserve(_dataModel, status) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString *  _Nullable x) {
        @strongify(self)
        self.statusLabel.text = [x integerValue] == 1?KLanguage(@"充值成功"):KLanguage(@"等待中");
        self.statusLabel.textColor = [x integerValue] == 1? Color(@"#54C23F"):Color(@"#D42204");
    }];
    [[RACObserve(_dataModel, type) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString *  _Nullable x) {
        @strongify(self)
        switch ([x intValue]) {
            case 1:
            {
                self.payTypeLabel.text = [NSString stringWithFormat:@"%@:%@",KLanguage(@"充值渠道"),KLanguage(@"支付宝")] ;
            }
                break;
            case 2:
            {
                self.payTypeLabel.text = [NSString stringWithFormat:@"%@:%@",KLanguage(@"充值渠道"),KLanguage(@"微信支付")] ;
            }
                break;
            case 3:
            {
                self.payTypeLabel.text = [NSString stringWithFormat:@"%@:%@",KLanguage(@"充值渠道"),KLanguage(@"苹果支付")] ;
            }
                break;
            case 4:
            {
                self.payTypeLabel.text = [NSString stringWithFormat:@"%@:%@",KLanguage(@"充值渠道"),KLanguage(@"微信小程序")] ;
            }
                break;
            case 5:
            {
                self.payTypeLabel.text = [NSString stringWithFormat:@"%@:%@",KLanguage(@"充值渠道"),KLanguage(@"paypal")] ;
            }
                break;
            case 6:
            {
                self.payTypeLabel.text = [NSString stringWithFormat:@"%@:%@",KLanguage(@"充值渠道"),KLanguage(@"braintree_paypal")] ;
            }
                break;
            case 7:
            {
                self.payTypeLabel.text = [NSString stringWithFormat:@"%@:%@",KLanguage(@"充值渠道"),KLanguage(@"丰汇支付")] ;
            }
                break;
            case 8:
            {
                self.payTypeLabel.text = [NSString stringWithFormat:@"%@:%@",KLanguage(@"充值渠道"),KLanguage(@"银行卡")] ;
            }
                break;
            case 9:
            {
                self.payTypeLabel.text = [NSString stringWithFormat:@"%@:%@",KLanguage(@"充值渠道"),KLanguage(@"虚拟币")] ;
            }
                break;
            default:
                break;
        }
     
    }];
    RAC(self.timeLabel,text) = [RACObserve(_dataModel, addtime)  takeUntil:self.rac_prepareForReuseSignal];
}

#pragma mark---- 懒加载 ----
- (UIView *)backView{
    if(!_backView){
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = ColorAlpha(@"#FFFFFF", 1);
        view.layer.cornerRadius = kUI_Width(4);
        view.clipsToBounds = YES;
        [self.contentView addSubview:view];
        _backView = view;
    }
    return _backView;
}

- (UILabel *)titleLabel{
    if(_titleLabel == nil){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
       
        label.font = MediumFont(14);
        label.textColor = Color(@"#333333");
        
 
        [self.backView addSubview:label];
        [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        _titleLabel = label;
    }
    return _titleLabel;
}
- (UILabel *)payTypeLabel{
    if(_payTypeLabel == nil){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
       
        label.font = RegularFont(14);
        label.textColor = Color(@"#666666");
        
 
        [self.backView addSubview:label];
        [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        _payTypeLabel = label;
    }
    return _payTypeLabel;
}
- (UILabel *)orderLabel{
    if(_orderLabel == nil){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
       
        label.font = RegularFont(14);
        label.textColor = Color(@"#666666");
        
 
        [self.backView addSubview:label];
        [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        _orderLabel = label;
    }
    return _orderLabel;
}
- (UILabel *)timeLabel{
    if(_timeLabel == nil){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
       
        label.font = RegularFont(14);
        label.textColor = Color(@"#666666");
        
 
        [self.backView addSubview:label];
        [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        _timeLabel = label;
    }
    return _timeLabel;
}
- (UILabel *)statusLabel{
    if (!_statusLabel){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textAlignment = NSTextAlignmentCenter;
        [self.backView addSubview:label];
        _statusLabel = label;
    //    self.time.textAlignment = NSTextAlignmentCenter;
        _statusLabel.font = RegularFont(12);
//        _statusLabel.textColor = Color(@"#333333");
    }
    return _statusLabel;
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
