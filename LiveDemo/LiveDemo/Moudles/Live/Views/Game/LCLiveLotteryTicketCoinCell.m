//
//  LCLiveLotteryTicketCoinCell.m
//  LiveDemo
//
//  Created by mrgao on 2023/3/22.
//

#import "LCLiveLotteryTicketCoinCell.h"

@interface LCLiveLotteryTicketCoinCell ()
@property (nonatomic , weak) UIImageView *backView;
@property (nonatomic , weak) UILabel *mainLabel;
@end
@implementation LCLiveLotteryTicketCoinCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
        [self.mainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(25));
            make.right.equalTo(-kUI_Width(5));
            make.height.equalTo(kUI_Width(14));
            make.centerY.equalTo(0);
        }];
    }
    return self;
}
- (void)setDataModel:(LCLotteryTicketCoinModel *)dataModel{
    _dataModel = dataModel;
    @weakify(self)
    
    [[RACObserve(_dataModel, isSelected) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSNumber *  _Nullable x) {
        @strongify(self)
        if([x boolValue]){
            self.backView.image = image(@"icon_liveLotteryTicketCoinSelectImg");
            
        }else{
            self.backView.image = image(@"icon_liveLotteryTicketCoinNormalImg");
            
        }
        
    }];
    RAC(self.mainLabel,text) = [RACObserve(_dataModel, coin) takeUntil:self.rac_prepareForReuseSignal] ;
    
}
#pragma mark---- 懒加载 ----
- (UIImageView *)backView{
    if(!_backView){
        UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectZero];
        view.image = image(@"icon_liveLotteryTicketCoinNormalImg");
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
        label.textColor = Color(@"#FFFFFF");
        label.textAlignment = NSTextAlignmentCenter;
        [self.backView addSubview:label];
        _mainLabel = label;
    }
    return _mainLabel;
}
@end
