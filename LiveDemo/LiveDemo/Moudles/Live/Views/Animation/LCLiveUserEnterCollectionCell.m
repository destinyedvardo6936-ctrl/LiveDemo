//
//  LCLiveUserEnterCollectionCell.m
//  LiveDemo
//
//  Created by mrgao on 2023/3/7.
//

#import "LCLiveUserEnterCollectionCell.h"

@interface LCLiveUserEnterCollectionCell ()
@property (nonatomic , weak) UIImageView *levelImgView;
@property (nonatomic , weak) UILabel *mainLabel;
@end
@implementation LCLiveUserEnterCollectionCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.levelImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
//            make.height.equalTo(kUI_Width(12));
            make.width.equalTo(kUI_Width(12));
            make.top.bottom.equalTo(0);
        }];
        [self.mainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(0);
            make.left.mas_equalTo(self.levelImgView.mas_right);
        }];
    }
    return self;
}

- (void)setDataModel:(LCLiveUserModel *)dataModel{
    _dataModel = dataModel;
    NSTextAttachment *adminAttchment = [[NSTextAttachment alloc]init];
    adminAttchment.bounds = CGRectMake(0, 0, kUI_Width(17), kUI_Width(12));
    adminAttchment.image = image(@"chat_admin");
    NSAttributedString *adminString = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(adminAttchment)];
    NSTextAttachment *shouAttchment = [[NSTextAttachment alloc]init];
    shouAttchment.bounds = CGRectMake(0, 0, kUI_Width(12), kUI_Width(12));
    shouAttchment.image = image(@"chat_shou_month");
    NSAttributedString *shouString = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(shouAttchment)];
    
    NSTextAttachment *yearAttchment = [[NSTextAttachment alloc]init];
    yearAttchment.bounds = CGRectMake(0, 0, kUI_Width(12), kUI_Width(12));
    yearAttchment.image = image(@"chat_shou_year");
    NSAttributedString *yearString = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(yearAttchment)];


    NSTextAttachment *vipAttchment = [[NSTextAttachment alloc]init];
    vipAttchment.bounds = CGRectMake(0, 0, kUI_Width(24), kUI_Width(12));//设置frame
    vipAttchment.image =image(@"chat_vip") ;
    NSAttributedString *vipString = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(vipAttchment)];
    NSTextAttachment *liangAttchment = [[NSTextAttachment alloc]init];
    liangAttchment.bounds = CGRectMake(0, 0, kUI_Width(16), kUI_Width(12));
    liangAttchment.image = image(@"chat_liang");
    NSAttributedString *liangString = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(liangAttchment)];
    NSArray *arr = [LCConfigManager shareManager].configModel.level;
    LCUserLevelModel *levelModel = nil;
    for (LCUserLevelModel *le in arr) {
        if([le.levelid integerValue] == [_dataModel.level integerValue]){
            levelModel = le;
        }
    }
    [self.levelImgView setImageStr:levelModel.thumb];
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:_dataModel.user_nicename attributes:@{NSFontAttributeName:RegularFont(12),NSForegroundColorAttributeName:Color(@"#86D9EF")}];
    [noteStr appendAttributedString:[[NSAttributedString alloc]initWithString:KLanguage(@"   来了") attributes:@{NSFontAttributeName:RegularFont(12),NSForegroundColorAttributeName:Color(@"#FFFFFF")}]];
    NSAttributedString *speaceString = [[NSAttributedString  alloc]initWithString:@" "];
//    //插入靓号图标
    if (![_dataModel.liang_name isEqual:@"0"] && ![_dataModel.liang_name isEqual:@"(null)"] && _dataModel.liang_name !=nil && _dataModel.liang_name !=NULL) {
        [noteStr insertAttributedString:speaceString atIndex:0];//插入到第几个下标
        [noteStr insertAttributedString:liangString atIndex:0];//插入到第几个下标
    }
    //插入守护图标
    if ([_dataModel.guard_type intValue] == 1) {
        [noteStr insertAttributedString:speaceString atIndex:0];//插入到第几个下标
        [noteStr insertAttributedString:shouString atIndex:0];//插入到第几个下标
    }
    if ([_dataModel.guard_type intValue] == 2) {
        [noteStr insertAttributedString:speaceString atIndex:0];//插入到第几个下标
        [noteStr insertAttributedString:yearString atIndex:0];//插入到第几个下标
    }
    //插入管理图标
    if ([_dataModel.issuper integerValue] == 1) {
        [noteStr insertAttributedString:speaceString atIndex:0];//插入到第几个下标
        [noteStr insertAttributedString:adminString atIndex:0];//插入到第几个下标
    }
    //插入VIP图标
    if ([_dataModel.vip_type integerValue] == 1) {
        [noteStr insertAttributedString:speaceString atIndex:0];//插入到第几个下标
        [noteStr insertAttributedString:vipString atIndex:0];//插入到第几个下标
    }
    
    
    self.mainLabel.attributedText = noteStr;
}
#pragma mark---- 懒加载 ----
- (UIImageView *)levelImgView{
    if(!_levelImgView){
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:imgView];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        _levelImgView = imgView;
    }
    return _levelImgView;
}
- (UILabel *)mainLabel{
    if (_mainLabel == nil){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.numberOfLines = 0;
        label.font = MediumFont(12);
        [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [self.contentView addSubview:label];
        _mainLabel = label;
        
    }
    return _mainLabel;
}
@end
