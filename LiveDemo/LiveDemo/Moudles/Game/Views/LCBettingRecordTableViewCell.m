//
//  LCBettingRecordTableViewCell.m
//  LiveDemo
//
//  Created by mrgao on 2023/3/17.
//

#import "LCBettingRecordTableViewCell.h"

@interface LCBettingRecordTableViewCell ()
@property (nonatomic , weak) UILabel *gameLabel;
@property (nonatomic , weak) UILabel *wanfaLabel;
@property (nonatomic , weak) UILabel *beishuLabel;
@property (nonatomic , weak) UILabel *amountLabel;
@property (nonatomic , weak) UILabel *expectLabel;
@property (nonatomic , weak) UILabel *statusLabel;
@end
@implementation LCBettingRecordTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubView];
    }
    return self;
}


-(void) initSubView{
    CGFloat width = (SCREEN_WIDTH - kUI_Width(12) * 2 -kUI_Width(90))/5.0;
    [self.gameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kUI_Width(12));
        make.height.equalTo(kUI_Width(12));
        make.width.equalTo(@(width));
        make.top.equalTo(kUI_Width(12));
       
    }];
    
    [self.wanfaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.gameLabel.mas_right);
       
        make.height.equalTo(kUI_Width(12));
        make.width.equalTo(@(width));
        make.top.equalTo(kUI_Width(12));
    }];
    [self.beishuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.wanfaLabel.mas_right);
        make.height.equalTo(kUI_Width(12));
        make.width.equalTo(@(width));
        make.top.equalTo(kUI_Width(12));
    }];
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.beishuLabel.mas_right);
        make.height.equalTo(kUI_Width(12));
        make.width.equalTo(@(width));
        make.top.equalTo(kUI_Width(12));
    }];
    [self.expectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.amountLabel.mas_right);
        make.width.equalTo(kUI_Width(90));
        make.height.equalTo(kUI_Width(12));
      
        make.top.equalTo(kUI_Width(12));
    }];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.expectLabel.mas_right);
        make.height.equalTo(kUI_Width(12));
        make.width.equalTo(@(width));
        make.top.equalTo(kUI_Width(12));
    }];
}
- (void)setDataModel:(LCBettingRecordModel *)dataModel{
    _dataModel = dataModel;
    @weakify(self)
    RAC(self.gameLabel, text) = [RACObserve(_dataModel, cptitle) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.wanfaLabel, text) = [RACObserve(_dataModel, playtitle) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.beishuLabel, text) = [RACObserve(_dataModel, beishu) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.amountLabel, text) = [RACObserve(_dataModel, amount) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.expectLabel, text) = [RACObserve(_dataModel, expect) takeUntil:self.rac_prepareForReuseSignal];
    [[RACObserve(_dataModel, is_show) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString *  _Nullable x) {
        @strongify(self)
        self.statusLabel.text = [x integerValue] == 1?KLanguage(@"中奖"):KLanguage(@"未中奖");
        self.statusLabel.textColor = [x integerValue] == 1? Color(@"#FF2828"):Color(@"#333333");
    }];
}



#pragma mark---- 懒加载 ----
- (UILabel *)gameLabel{
    if (!_gameLabel){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
//        label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label];
        _gameLabel = label;
       
        _gameLabel.font = RegularFont(12);
        _gameLabel.textColor = Color(@"#333333");
    }
    return _gameLabel;
}
- (UILabel *)wanfaLabel{
    if (!_wanfaLabel){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label];
        _wanfaLabel = label;
    //    self.time.textAlignment = NSTextAlignmentCenter;
        _wanfaLabel.font = RegularFont(12);
        _wanfaLabel.textColor = Color(@"#333333");
    }
    return _wanfaLabel;
}
- (UILabel *)beishuLabel{
    if (!_beishuLabel){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label];
        _beishuLabel = label;
    //    self.time.textAlignment = NSTextAlignmentCenter;
        _beishuLabel.font = RegularFont(12);
        _beishuLabel.textColor = Color(@"#333333");
    }
    return _beishuLabel;
}
- (UILabel *)amountLabel{
    if (!_amountLabel){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label];
        _amountLabel = label;
    //    self.time.textAlignment = NSTextAlignmentCenter;
        _amountLabel.font = RegularFont(12);
        _amountLabel.textColor = Color(@"#333333");
    }
    return _amountLabel;
}
- (UILabel *)expectLabel{
    if (!_expectLabel){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label];
        _expectLabel = label;
    //    self.time.textAlignment = NSTextAlignmentCenter;
        _expectLabel.font = RegularFont(12);
        _expectLabel.textColor = Color(@"#333333");
    }
    return _expectLabel;
}
- (UILabel *)statusLabel{
    if (!_statusLabel){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label];
        _statusLabel = label;
    //    self.time.textAlignment = NSTextAlignmentCenter;
        _statusLabel.font = RegularFont(12);
        _statusLabel.textColor = Color(@"#333333");
    }
    return _statusLabel;
}

@end
