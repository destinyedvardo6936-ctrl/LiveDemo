//
//  LCAccountDetailsTableViewCell.m
//  LiveDemo
//
//  Created by mrgao on 2023/6/8.
//

#import "LCAccountDetailsTableViewCell.h"

@interface LCAccountDetailsTableViewCell ()
@property (nonatomic , weak) UIView *backView;
@property (nonatomic , weak) UILabel *titleLabel;
@property (nonatomic , weak) UILabel *typeLabel;
@end
@implementation LCAccountDetailsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.right.equalTo(-kUI_Width(12));
            make.top.equalTo(0);
            make.bottom.equalTo(0);
            make.height.equalTo(kUI_Width(40));
        }];
       
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.height.equalTo(kUI_Width(14));
            make.right.mas_equalTo(self.typeLabel.mas_left).offset(-kUI_Width(10));
            make.centerY.equalTo(0);
           
        }];
        [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-kUI_Width(12));
            make.height.equalTo(kUI_Width(14));
       
            make.centerY.mas_equalTo(self.titleLabel.mas_centerY);
        }];
      
      
        
    }
    return self;
}
- (void)setDataModel:(LCAccountDetailsModel *)dataModel{
    _dataModel = dataModel;
    @weakify(self)
    
    RAC(self.titleLabel,text) = [[[RACSignal combineLatest:@[RACObserve(_dataModel, action),RACObserve(_dataModel, totalcoin)]]map:^id _Nullable(RACTuple * _Nullable value) {
        NSString *titStr = value[0];
        NSString *money = value[1];
        if(!titStr && !money){
            return nil;
        }
        return [NSString stringWithFormat:@"%@:%@%@",titStr,money,KLanguage(@"钻石")];
    }] takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.typeLabel,text) = [RACObserve(_dataModel, type) takeUntil:self.rac_prepareForReuseSignal];
    
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
- (UILabel *)typeLabel{
    if(_typeLabel == nil){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
       
        label.font = RegularFont(14);
        label.textColor = Color(@"#333333");
        
 
        [self.backView addSubview:label];
        [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        _typeLabel = label;
    }
    return _typeLabel;
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
