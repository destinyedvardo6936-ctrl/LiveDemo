//
//  LCLiveLotteryTicketWanfaCollectionCell.m
//  LiveDemo
//
//  Created by mrgao on 2023/3/23.
//

#import "LCLiveLotteryTicketWanfaCollectionCell.h"

@interface LCLiveLotteryTicketWanfaCollectionCell ()
@property (nonatomic , weak) UIView *backView;
@property (nonatomic , weak) UILabel *nameLabel;
@property (nonatomic , weak) UILabel *moneyLabel;
@end
@implementation LCLiveLotteryTicketWanfaCollectionCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(0);
            make.bottom.mas_equalTo(self.moneyLabel.mas_top).offset(-kUI_Width(15));
        }];
        [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.height.equalTo(kUI_Width(16));
            make.bottom.equalTo(0);
        }];
    }
    return self;
}
- (void)setDataModel:(LCLotteryTicketWanFaModel *)dataModel{
    _dataModel = dataModel;
    @weakify(self)
    RAC(self.nameLabel,text) = [RACObserve(_dataModel, name) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.moneyLabel,text) = [RACObserve(_dataModel, peilv) takeUntil:self.rac_prepareForReuseSignal];
    [[RACObserve(_dataModel, isSelected) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSNumber *  _Nullable x) {
        @strongify(self)
        if([x boolValue]){
           
            self.backView.backgroundColor = Color(@"#FF63A7");
        }else{
            ;
            self.backView.backgroundColor = Color(@"#FFFFFF");
        }
        
    }];
}
#pragma mark---- 懒加载 ----
- (UIView *)backView{
    if(!_backView){
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = Color(@"#FFFFFF");
        view.layer.cornerRadius = kUI_Width(4);
        [self.contentView addSubview:view];
        _backView = view;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = RegularFont(18);
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = Color(@"#333333");
        [_backView addSubview:label];
        _nameLabel = label;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(0);
        }];
    }
    return _backView;
}
- (UILabel *)moneyLabel{
    if(!_moneyLabel){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = RegularFont(16);
        label.textColor = Color(@"#FFFFFF");
        label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label];
        _moneyLabel = label;
    }
    return _moneyLabel;
}

@end
