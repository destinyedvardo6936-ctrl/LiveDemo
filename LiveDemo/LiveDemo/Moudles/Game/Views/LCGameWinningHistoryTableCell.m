//
//  LCGameWinningHistoryTableCell.m
//  LiveDemo
//
//  Created by mrgao on 2023/3/17.
//

#import "LCGameWinningHistoryTableCell.h"

@interface LCGameWinningHistoryTableCell ()
@property (nonatomic, weak) UIView *backView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *termLabel;
@property (nonatomic , weak) UIView *bottomView;
@end
@implementation LCGameWinningHistoryTableCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(0);
            make.left.equalTo(kUI_Width(12));
            make.right.equalTo(-kUI_Width(12));
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.top.equalTo(kUI_Width(8));
            make.height.equalTo(kUI_Width(14));
        }];
        [self.termLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(kUI_Width(14));
            make.left.mas_equalTo(self.nameLabel.mas_right).offset(kUI_Width(12));
            make.centerY.mas_equalTo(self.nameLabel.mas_centerY);
            make.right.equalTo(-kUI_Width(12));
        }];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(0);
            make.top.equalTo(kUI_Width(30));
        }];
    }

    return self;
}

- (void)setDataModel:(LCGameWinningHistoryModel *)dataModel {
    _dataModel = dataModel;
    @weakify(self);
    RAC(self.nameLabel, text) = [RACObserve(_dataModel, title) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.termLabel, text) = [RACObserve(_dataModel, expect) takeUntil:self.rac_prepareForReuseSignal];
    [self.bottomView removeAllSubviews];
    if (_dataModel.opencode.length > 1) {
        NSArray *array = [_dataModel.opencode componentsSeparatedByString:@","];

        for (int i = 0; i < array.count; i++) {
            UILabel *sixLabel = [[UILabel alloc] init];
//            sixLabel.frame = CGRectMake(15 + (itemSize  + 5) * i, LinRealValue(45), itemSize, itemSize);
            sixLabel.text = array[i];
            sixLabel.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1.0];
            sixLabel.textColor = Color(@"#FFFFFF");
            sixLabel.textAlignment = NSTextAlignmentCenter;
            sixLabel.font = MediumFont(12);
            sixLabel.layer.cornerRadius = kUI_Width(4);
            sixLabel.clipsToBounds = YES;

            [self.bottomView addSubview:sixLabel];
            [sixLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(kUI_Width(12) + kUI_Width(16) * i + i *kUI_Width(9));
                make.width.height.equalTo(kUI_Width(16));
                make.top.equalTo(kUI_Width(8));
            }];
        }
    }
}

#pragma mark---- 懒加载 ----
- (UIView *)backView {
    if (!_backView) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = ColorAlpha(@"#FFFFFF", 1);
        view.layer.cornerRadius = kUI_Width(4);
        view.clipsToBounds = YES;
        [self.contentView addSubview:view];
        _backView = view;
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectZero];
        lineView.backgroundColor = Color(@"#F2F2F6");
        [_backView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.height.equalTo(1);
            make.top.equalTo(kUI_Width(30));
        }];
    }

    return _backView;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];

        label.font = MediumFont(14);
        label.textColor = Color(@"#333333");
//        label.text = KLanguage(@"系统消息");

        [self.backView addSubview:label];
        [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        _nameLabel = label;
    }

    return _nameLabel;
}

- (UILabel *)termLabel {
    if (_termLabel == nil) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];

        label.font = RegularFont(14);
        label.textColor = Color(@"#666666");
//        label.text = KLanguage(@"系统消息");

        [self.backView addSubview:label];
//        [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
//        [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        _termLabel = label;
    }

    return _termLabel;
}
- (UIView *)bottomView{
    if(!_bottomView){
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor clearColor];
        [self.backView addSubview:view];
        _bottomView = view;
    }
    return _bottomView;
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
