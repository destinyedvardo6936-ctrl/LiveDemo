//
//  LCMineWalletAndMeaageCell.m
//  LiveDemo
//
//  Created by mrgao on 2023/1/7.
//

#import "LCMineWalletAndMeaageCell.h"

@interface LCMineWalletAndMeaageCell ()
//@property (nonatomic , weak) UIView *walletBackView;
//@property (nonatomic , weak) UILabel *walletLabel;
@property (nonatomic , weak) UIView *messageBackView;
@property (nonatomic , weak) UILabel *messageLabel;
@end
@implementation LCMineWalletAndMeaageCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        [self.walletBackView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(kUI_Width(kViewMargin));
//            make.height.equalTo(kUI_Width(80));
//            make.width.mas_equalTo(self.messageBackView.mas_width);
//            make.top.bottom.equalTo(0);
//        }];
        [self.messageBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-kUI_Width(kViewMargin));
            make.height.equalTo(kUI_Width(80));
//            make.width.mas_equalTo(self.walletBackView.mas_width);
            make.top.bottom.equalTo(0);
            make.left.equalTo(kUI_Width(kViewMargin));
//            make.left.mas_equalTo(self.walletBackView.mas_right).offset(kUI_Width(10));
        }];
    }
    return self;
}
- (void)setDataModel:(LCMessageListModel *)dataModel{
    _dataModel = dataModel;
    RAC(self.messageLabel,text) = [RACObserve(_dataModel, content) takeUntil:self.rac_prepareForReuseSignal];
}
#pragma mark---- 懒加载 ----
//- (UIView *)walletBackView{
//    if(!_walletBackView){
//        UIView *view = [[UIView alloc] init];
//        view.backgroundColor = Color(@"#FFFFFF ");
//        view.layer.cornerRadius = kUI_Width(4);
//        view.layer.shadowColor = Color(@"#F1EEEF").CGColor;
//        view.layer.shadowOffset = CGSizeMake(0,1);
//        view.layer.shadowOpacity = 1;
//        view.layer.shadowRadius = 2;
//        [self.contentView addSubview:view];
//        WS(weakSelf)
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
//            [weakSelf.clickSubject sendNext:@(0)];
//        }];
//        [view addGestureRecognizer:tap];
//        _walletBackView = view;
//        UILabel *label1 = [[UILabel alloc] init];
//        label1.textColor = Color(@"#333333");
//        label1.font = BoldFont(16);
//        label1.text = KLanguage(@"波币钱包");
//        [_walletBackView addSubview:label1];
//        UILabel *label2 = [[UILabel alloc] init];
//        label2.textColor = Color(@"#999999");
//        label2.font = RegularFont(14);
//        label2.numberOfLines = 2;
//        [_walletBackView addSubview:label2];
//        _walletLabel = label2;
//        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.top.equalTo(kUI_Width(kViewMargin));
//            make.height.equalTo(kUI_Width(16));
//        }];
//        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(kUI_Width(kViewMargin));
//            make.right.equalTo(-kUI_Width(100));
//            make.top.mas_equalTo(label1.mas_bottom).offset(kUI_Width(10));
//           
//        }];
//    }
//    return _walletBackView;
//}
- (UIView *)messageBackView{
    if(!_messageBackView){
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = Color(@"#FFFFFF ");
        view.layer.cornerRadius = kUI_Width(4);
        view.layer.shadowColor = Color(@"#F1EEEF").CGColor;
        view.layer.shadowOffset = CGSizeMake(0,1);
        view.layer.shadowOpacity = 1;
        view.layer.shadowRadius = 2;
        [self.contentView addSubview:view];
        WS(weakSelf)
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            [weakSelf.clickSubject sendNext:@(1)];
        }];
        [view addGestureRecognizer:tap];
        _messageBackView = view;
        UILabel *label1 = [[UILabel alloc] init];
        label1.textColor = Color(@"#333333");
        label1.font = BoldFont(16);
        label1.text = KLanguage(@"消息");
        [_messageBackView addSubview:label1];
        UILabel *label2 = [[UILabel alloc] init];
        label2.textColor = Color(@"#999999");
        label2.font = RegularFont(14);
        label2.numberOfLines = 2;
        [_messageBackView addSubview:label2];
        _messageLabel = label2;
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(kUI_Width(kViewMargin));
            make.height.equalTo(kUI_Width(16));
        }];
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(kViewMargin));
            make.right.equalTo(-kUI_Width(100));
            make.top.mas_equalTo(label1.mas_bottom).offset(kUI_Width(10));
           
        }];
    }
    return _messageBackView;
}
- (RACSubject *)clickSubject{
    if(_clickSubject == nil){
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
