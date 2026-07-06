//
//  LCAreaNumberTableViewCell.m
//  LiveDemo
//
//  Created by mrgao on 2023/1/31.
//

#import "LCAreaNumberTableViewCell.h"

@interface LCAreaNumberTableViewCell ()
@property (nonatomic , weak) UIView *backView;
@property (nonatomic , weak) UILabel *leftLabel;
@property (nonatomic , weak) UILabel *rightLabel;
@end
@implementation LCAreaNumberTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.right.equalTo(-kUI_Width(34));
            make.top.equalTo(0);
            make.bottom.equalTo(-kUI_Width(1));
        }];
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.centerY.equalTo(0);
            make.right.mas_lessThanOrEqualTo(self.rightLabel.mas_left).offset(-kUI_Width(15));
            make.height.equalTo(kUI_Width(20));
        }];
        [self.leftLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.leftLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        
        [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-kUI_Width(12));
            make.centerY.equalTo(0);
            make.height.equalTo(kUI_Width(20));
        }];
        [self.rightLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.rightLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        
    }
    return self;
}
- (void)setDataModel:(LCAreaNumberModel *)dataModel{
    _dataModel = dataModel;
    RAC(self.leftLabel,text) = [RACObserve(_dataModel, name) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.rightLabel,text) = [[RACObserve(_dataModel, tel) map:^NSString * _Nullable(NSString *  _Nullable value) {
        if(!value.length){
            return nil;
        }
        return [NSString stringWithFormat:@"+%@",value];
    }] takeUntil:self.rac_prepareForReuseSignal];
}
#pragma mark---- 懒加载 ----
- (UIView *)backView{
    if(!_backView){
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = Color(@"#FFFFFF");
        view.layer.cornerRadius = kUI_Width(4);
        [self.contentView addSubview:view];
        _backView = view;
    }
    return _backView;
}
- (UILabel *)leftLabel{
    if(_leftLabel == nil){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.textColor = Color(@"#333333");
        label.font = MediumFont(14);
        [self.backView addSubview:label];
        _leftLabel = label;
    }
    return _leftLabel;
}
- (UILabel *)rightLabel{
    if(_rightLabel == nil){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.textColor = Color(@"#666666");
        label.font = MediumFont(14);
        label.textAlignment = NSTextAlignmentRight;
        [self.backView addSubview:label];
        _rightLabel = label;
    }
    return _rightLabel;
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
