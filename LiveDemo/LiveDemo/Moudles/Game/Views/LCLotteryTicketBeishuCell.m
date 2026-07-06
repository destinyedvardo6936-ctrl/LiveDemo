//
//  LCLotteryTicketBeishuCell.m
//  LiveDemo
//
//  Created by mrgao on 2023/3/22.
//

#import "LCLotteryTicketBeishuCell.h"

@interface LCLotteryTicketBeishuCell ()
@property (nonatomic , weak) UIView *backView;
@property (nonatomic , weak) UILabel *mainLabel;
@end
@implementation LCLotteryTicketBeishuCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
        [self.mainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.height.equalTo(kUI_Width(14));
            make.centerY.equalTo(0);
        }];
    }
    return self;
}
- (void)setDataModel:(LCLotteryTicketBeishuModel *)dataModel{
    _dataModel = dataModel;
    @weakify(self)
    
    [[RACObserve(_dataModel, isSelected) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSNumber *  _Nullable x) {
        @strongify(self)
        if([x boolValue]){
            self.backView.backgroundColor = Color(@"#FF3C83");
            self.backView.layer.borderWidth = 0;
            self.backView.layer.borderColor = Color(@"#FF3C83").CGColor;
            self.mainLabel.textColor = Color(@"#FFFFFF");
        }else{
            self.backView.backgroundColor = Color(@"#FFFFFF");
            self.backView.layer.borderWidth = 1;
            self.backView.layer.borderColor = Color(@"#CCCCCC").CGColor;
            self.mainLabel.textColor = Color(@"#666666");
        }
        
    }];
    RAC(self.mainLabel,text) = [[RACObserve(_dataModel, name) map:^NSString * _Nullable(NSString *  _Nullable value) {
        if(!value.length){
            return nil;
        }
        return [NSString stringWithFormat:@"%@%@",value,KLanguage(@"倍")];
    }]takeUntil:self.rac_prepareForReuseSignal] ;
    
}
#pragma mark---- 懒加载 ----
- (UIView *)backView{
    if(!_backView){
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = ColorAlpha(@"#FFFFFF", 1);
        view.layer.cornerRadius = kUI_Width(30)/2;
        view.layer.borderWidth = 1;
        view.layer.borderColor = Color(@"#CCCCCC").CGColor;
        view.clipsToBounds = YES;
        [self.contentView addSubview:view];
        _backView = view;
    }
    return _backView;
}
- (UILabel *)mainLabel{
    if(_mainLabel == nil){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = RegularFont(14);
        label.textColor = Color(@"#666666");
        label.textAlignment = NSTextAlignmentCenter;
        [self.backView addSubview:label];
        _mainLabel = label;
    }
    return _mainLabel;
}
@end
