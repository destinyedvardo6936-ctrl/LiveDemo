//
//  LCLotteryTicketConfirmTableCell.m
//  LiveDemo
//
//  Created by mrgao on 2023/3/22.
//

#import "LCLotteryTicketConfirmTableCell.h"

@interface LCLotteryTicketConfirmTableCell ()
@property (nonatomic , weak) UILabel *nameLabel;
@property (nonatomic , weak) UILabel *peilvLabel;
@property (nonatomic , weak) UIView *moneyBackView;
@property (nonatomic , weak) UIButton *moneyBtn;
@property (nonatomic , weak) UIView *deleteView;
@property (nonatomic , weak) UIButton *deleteBtn;
@end
@implementation LCLotteryTicketConfirmTableCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(kUI_WidthWithFloat(150));
            make.height.equalTo(kUI_Width(32));
            make.top.left.equalTo(0);
        }];
        [self.peilvLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(kUI_WidthWithFloat(70));
            make.height.equalTo(kUI_Width(32));
            make.top.equalTo(0);
            make.left.mas_equalTo(self.nameLabel.mas_right);
        }];
        [self.moneyBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(kUI_WidthWithFloat(98));
            make.height.equalTo(kUI_Width(32));
            make.top.equalTo(0);
            make.left.mas_equalTo(self.peilvLabel.mas_right);
        }];
        [self.deleteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(0);
            make.height.equalTo(kUI_Width(32));
            make.top.equalTo(0);
            make.left.mas_equalTo(self.moneyBackView.mas_right);
        }];
    }
    return self;
}
- (void)setDataModel:(LCLotteryTicketWanFaModel *)dataModel{
    _dataModel = dataModel;
    @weakify(self)
    [[[RACSignal combineLatest:@[RACObserve(_dataModel, gameName),RACObserve(_dataModel, wanfaname),RACObserve(_dataModel, name)]]takeUntil:self.rac_prepareForReuseSignal]subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self)
        NSString *gameName = x[0];
        NSString *wanfaName = x[1];
        NSString *name = x[2];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]init];
        [str appendAttributedString:[[NSAttributedString alloc]initWithString:gameName.length ? gameName : @""]];
        [str appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"-%@|",wanfaName.length?wanfaName:@""]]];
        [str appendAttributedString:[[NSAttributedString alloc]initWithString:name.length?name:@"" attributes:@{NSForegroundColorAttributeName:Color(@"#FF3232")}]];
        self.nameLabel.attributedText = str;
     }] ;
    RAC(self.peilvLabel,text) = [RACObserve(_dataModel, peilv) takeUntil:self.rac_prepareForReuseSignal] ;
    [[RACObserve(_dataModel, coin) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString *  _Nullable x) {
        @strongify(self)
        [self.moneyBtn setTitle:x forState:UIControlStateNormal];
    }] ;
    
}
#pragma mark---- 懒加载 ----
- (UILabel *)nameLabel{
    if(!_nameLabel){
        UILabel *wanfaLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        wanfaLabel.font = RegularFont(12);
        wanfaLabel.textColor = Color(@"#666666");
//        wanfaLabel.text = KLanguage(@"玩法");
        wanfaLabel.textAlignment = NSTextAlignmentCenter;
        wanfaLabel.layer.borderWidth = 0.5;
        wanfaLabel.layer.borderColor = Color(@"#CCCCCC").CGColor;
        [self.contentView addSubview:wanfaLabel];
        _nameLabel = wanfaLabel;
    }
    return _nameLabel;
}
- (UILabel *)peilvLabel{
    if(!_peilvLabel){
        UILabel *wanfaLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        wanfaLabel.font = RegularFont(14);
        wanfaLabel.textColor = Color(@"#328FFF");
//        wanfaLabel.text = KLanguage(@"玩法");
        wanfaLabel.textAlignment = NSTextAlignmentCenter;
        wanfaLabel.layer.borderWidth = 0.5;
        wanfaLabel.layer.borderColor = Color(@"#CCCCCC").CGColor;
        [self.contentView addSubview:wanfaLabel];
        _peilvLabel = wanfaLabel;
    }
    return _peilvLabel;
}
- (UIView *)moneyBackView{
    if(!_moneyBackView){
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.layer.borderWidth = 0.5;
        view.layer.borderColor = Color(@"#CCCCCC").CGColor;
        [self.contentView addSubview:view];
        _moneyBackView = view;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.layer.cornerRadius = kUI_Width(24)/2.0;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = Color(@"#CCCCCC").CGColor;
        [btn setTitleColor:Color(@"#333333") forState:UIControlStateNormal];
        btn.titleLabel.font = RegularFont(14);
        
        [_moneyBackView addSubview:btn];
        _moneyBtn = btn;
        WS(weakSelf)
        [[_moneyBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if(weakSelf.moneyClickBlock){
                weakSelf.moneyClickBlock(weakSelf.dataModel);
            }
        }];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(kUI_Width(80));
            make.height.equalTo(kUI_Width(24));
            make.centerY.centerX.equalTo(0);
        }];
    }
    return _moneyBackView;
}
- (UIView *)deleteView{
    if(!_deleteView){
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.layer.borderWidth = 0.5;
        view.layer.borderColor = Color(@"#CCCCCC").CGColor;
        [self.contentView addSubview:view];
        _deleteView = view;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:image(@"icon_lotteryTicketDeleteImg") forState:UIControlStateNormal];
//        btn.titleLabel.font = RegularFont(14);
        
        [_deleteView addSubview:btn];
//        _moneyBtn = btn;
        WS(weakSelf)
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if(weakSelf.deleteBlock){
                weakSelf.deleteBlock(weakSelf.dataModel);
            }
        }];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(kUI_Width(20));
            make.height.equalTo(kUI_Width(20));
            make.centerY.centerX.equalTo(0);
        }];
    }
    return _deleteView;
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
