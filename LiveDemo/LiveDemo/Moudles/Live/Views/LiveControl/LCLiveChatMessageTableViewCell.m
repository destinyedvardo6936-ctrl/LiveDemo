//
//  LCLiveChatMessageTableViewCell.m
//  LiveDemo
//
//  Created by mrgao on 2023/3/7.
//

#import "LCLiveChatMessageTableViewCell.h"
#import <YYText/YYText.h>
#import <YYAnimatedImageView.h>
@interface LCLiveChatMessageTableViewCell ()
@property (nonatomic , weak) UIView *backView;
//@property (nonatomic , weak) UIImageView *levelImgView;
@property (nonatomic , weak) YYLabel *mainLabel;
@end
@implementation LCLiveChatMessageTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.equalTo(0);
        }];
//        [self.levelImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(kUI_Width(12));
//            make.height.equalTo(RegularFont(12).lineHeight);
//            make.width.equalTo(RegularFont(12).lineHeight);
//            make.top.equalTo(kUI_Width(8));
//        }];
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
    if(_dataModel.type == 1){
        self.mainLabel.attributedText = dataModel.attContent;
    
    }else if (_dataModel.type == 6){
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc]init];
        UIImageView *xitongImgView = [[UIImageView alloc]initWithImage:image(@"icon_liveSocketKaiJiangImg")];
        xitongImgView.frame = CGRectMake(0, 0, kUI_Width(30), kUI_Width(12));
        NSMutableAttributedString *attachTextRecahrage = [NSMutableAttributedString yy_attachmentStringWithContent:xitongImgView contentMode:UIViewContentModeLeft attachmentSize:xitongImgView.bounds.size alignToFont:MediumFont(12) alignment:YYTextVerticalAlignmentCenter];
        
        [att  appendAttributedString:attachTextRecahrage];
        [att appendAttributedString:[[NSAttributedString alloc]initWithString:@" " attributes:@{NSForegroundColorAttributeName:Color(@"#86D9EF"),NSFontAttributeName:MediumFont(12)}]];
 
        NSMutableAttributedString *contentAtt = [[NSMutableAttributedString alloc]initWithString:_dataModel.content.length?_dataModel.content:@"" attributes:@{NSForegroundColorAttributeName:Color(@"#FFFFFF"),NSFontAttributeName:MediumFont(12)}];
       
        
        [att appendAttributedString:contentAtt];
        self.mainLabel.attributedText = att;
    }else {
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithAttributedString:_dataModel.attContent];
        NSArray *arr = [LCConfigManager shareManager].configModel.level;
        LCUserLevelModel *levelModel = nil;
        for (LCUserLevelModel *le in arr) {
            if([le.levelid integerValue] == [_dataModel.level integerValue]){
                levelModel = le;
            }
        }
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, RegularFont(12).lineHeight, RegularFont(12).lineHeight)];
        // 加载网络图片
//        NSURL *url = [NSURL URLWithString:levelModel.thumb];
        [imageView setImageStr:levelModel.thumb];
        
        // 将UIImage转换为NSAttributedString
        NSAttributedString *imageString = [NSAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:imageView.bounds.size alignToFont:RegularFont(12) alignment:YYTextVerticalAlignmentCenter];
        // 添加图片和文字
        [att insertAttributedString:imageString atIndex:0];
        self.mainLabel.attributedText = att;
    }
    
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
//- (UIImageView *)levelImgView{
//    if(!_levelImgView){
//        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
//        [self.backView addSubview:imgView];
//        imgView.contentMode = UIViewContentModeScaleAspectFill;
//        _levelImgView = imgView;
//    }
//    return _levelImgView;
//}
- (YYLabel *)mainLabel{
    if (_mainLabel == nil){
        YYLabel *label = [[YYLabel alloc]initWithFrame:CGRectZero];
        label.numberOfLines = 0;
        label.font = RegularFont(12);
        [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        label.preferredMaxLayoutWidth = kUI_Width(264) - kUI_Width(12) * 2;
        [self.backView addSubview:label];
        _mainLabel = label;
        
    }
    return _mainLabel;
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
