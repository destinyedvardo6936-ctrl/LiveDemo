//
//  LCUpdatePersonalAvaterCell.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/18.
//

#import "LCUpdatePersonalAvaterCell.h"

@interface LCUpdatePersonalAvaterCell ()
@property (nonatomic , weak) UIView *backView;
@property (nonatomic , weak) UILabel *tipLabel;
@property (nonatomic , weak) UIImageView *avaterImgView;

@end
@implementation LCUpdatePersonalAvaterCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.right.equalTo(-kUI_Width(12));
            make.top.equalTo(0);
            make.bottom.equalTo(0);
            make.height.equalTo(kUI_Width(80));
        }];
        [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.height.equalTo(kUI_Width(20));
            make.width.lessThanOrEqualTo(kUI_Width(100));
            make.top.equalTo(kUI_Width(15));
           
        }];
        [self.avaterImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-kUI_Width(12));
            make.width.height.equalTo(kUI_Width(70));
           
            make.centerY.equalTo(0);
           
        }];
        
        
    }
    return self;
}
- (void)setAvatar:(id)avatar{
    _avatar = avatar;
    if([_avatar isKindOfClass:NSString.class]){
        NSString *str = _avatar;
        [self.avaterImgView setImageStr:str];
    }else if ([_avatar isKindOfClass:UIImage.class]){
        UIImage *img = _avatar;
        self.avaterImgView.image = img;
    }
}

#pragma mark---- 懒加载 ----
- (UIView *)backView{
    if(!_backView){
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = ColorAlpha(@"#FFFFFF", 1);
        view.layer.cornerRadius = kUI_Width(4);
        view.clipsToBounds = YES;
        [self.contentView addSubview:view];
        _backView = view;
    }
    return _backView;
}
- (UIImageView *)avaterImgView {
    if (_avaterImgView == nil) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _avaterImgView = imgView;
        _avaterImgView.contentMode = UIViewContentModeScaleAspectFit;
    
        _avaterImgView.layer.masksToBounds = YES;
        _avaterImgView.layer.cornerRadius = kUI_Width(70)/2.0;
//        _mainImgView.clipsToBounds = YES;
        [self.backView addSubview:_avaterImgView];
    }

    return _avaterImgView;
}
- (UILabel *)tipLabel{
    if(_tipLabel == nil){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
       
        label.font = MediumFont(14);
        label.textColor = Color(@"#333333");
        label.text = KLanguage(@"头像：");
 
        [self.backView addSubview:label];
        [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        _tipLabel = label;
    }
    return _tipLabel;
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
