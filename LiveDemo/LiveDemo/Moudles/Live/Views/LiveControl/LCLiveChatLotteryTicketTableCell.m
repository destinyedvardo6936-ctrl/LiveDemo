//
//  LCLiveChatLotteryTicketTableCell.m
//  LiveDemo
//
//  Created by mrgao on 2023/3/24.
//

#import "LCLiveChatLotteryTicketTableCell.h"
#import <YYText/YYText.h>
@interface LCLiveChatLotteryTicketTableCell ()
@property (nonatomic , weak) UIView *backView;

@property (nonatomic , weak) YYLabel *mainLabel;
@end
@implementation LCLiveChatLotteryTicketTableCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.equalTo(0);
        }];
        
        [self.mainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12)) ;
            make.right.equalTo(-kUI_Width(12));
            make.top.equalTo(kUI_Width(8));
            make.bottom.equalTo(-kUI_Width(8));
        }];
    }
    return self;
}
- (void)setDataModel:(LCChatMessageModel *)dataModel{
    _dataModel = dataModel;
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]init];
    UIImageView *xitongImgView = [[UIImageView alloc]initWithImage:image(@"icon_liveSocketSystem")];
    xitongImgView.frame = CGRectMake(0, 0, kUI_Width(30), kUI_Width(12));
    NSMutableAttributedString *attachTextRecahrage = [NSMutableAttributedString yy_attachmentStringWithContent:xitongImgView contentMode:UIViewContentModeLeft attachmentSize:xitongImgView.bounds.size alignToFont:MediumFont(12) alignment:YYTextVerticalAlignmentCenter];
    
    [att  appendAttributedString:attachTextRecahrage];
    [att appendAttributedString:[[NSAttributedString alloc]initWithString:@" " attributes:@{NSForegroundColorAttributeName:Color(@"#86D9EF"),NSFontAttributeName:MediumFont(12)}]];
//    [att appendAttributedString:[[NSAttributedString alloc]initWithString:_dataModel.uname attributes:@{NSForegroundColorAttributeName:Color(@"#86D9EF"),NSFontAttributeName:MediumFont(12)}]];
    NSMutableAttributedString *contentAtt = [[NSMutableAttributedString alloc]initWithString:_dataModel.content attributes:@{NSForegroundColorAttributeName:Color(@"#FFFFFF"),NSFontAttributeName:MediumFont(12)}];
   
    if([_dataModel.content containsString:_dataModel.uname]){
        NSRange range = [_dataModel.content rangeOfString:_dataModel.uname];
        [contentAtt addAttributes:@{NSForegroundColorAttributeName:Color(@"#86D9EF")} range:range];
    }
    [att appendAttributedString:contentAtt];
    [att appendAttributedString:[[NSAttributedString alloc]initWithString:@" " attributes:@{NSForegroundColorAttributeName:Color(@"#FFFFFF"),NSFontAttributeName:MediumFont(12)}]];
    UIImageView *gentouImgView = [[UIImageView alloc]initWithImage:image(@"icon_liveSocketGenATou")];
    gentouImgView.frame = CGRectMake(0, 0, kUI_Width(40), kUI_Width(18));
    NSMutableAttributedString *attachTextRecahrage1 = [NSMutableAttributedString yy_attachmentStringWithContent:gentouImgView contentMode:UIViewContentModeLeft attachmentSize:gentouImgView.bounds.size alignToFont:MediumFont(12) alignment:YYTextVerticalAlignmentCenter];
    
    YYTextHighlight *highlight = [YYTextHighlight new];
    [highlight setColor:[UIColor clearColor]];
    WS(weakSelf)
    highlight.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        // 点击事件处理
        if(weakSelf.btnClickedBlock){
            weakSelf.btnClickedBlock(weakSelf.dataModel);
        }
    };
    [attachTextRecahrage1 yy_setTextHighlight:highlight range:NSMakeRange(0, attachTextRecahrage1.length)];
    
    [att  appendAttributedString:attachTextRecahrage1];
    
    
    self.mainLabel.attributedText = att;
}

#pragma mark---- 懒加载 ----
- (UIView *)backView{
    if(!_backView){
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = ColorAlpha(@"#000000 ", 0.3);
        view.layer.cornerRadius = kUI_Width(8);
        view.clipsToBounds = YES;
        [self.contentView addSubview:view];
        _backView = view;
    }
    return _backView;
}

- (YYLabel *)mainLabel{
    if (_mainLabel == nil){
        YYLabel *label = [[YYLabel alloc]initWithFrame:CGRectZero];
        label.numberOfLines = 0;
        label.font = MediumFont(12);
        [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        label.preferredMaxLayoutWidth = kUI_Width(264) - kUI_Width(12) * 2;
        [self.backView addSubview:label];
        _mainLabel = label;
        
    }
    return _mainLabel;
}

@end
