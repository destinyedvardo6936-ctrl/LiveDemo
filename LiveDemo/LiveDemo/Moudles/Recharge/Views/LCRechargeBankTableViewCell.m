//
//  LCRechargeBankTableViewCell.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/16.
//

#import "LCRechargeBankTableViewCell.h"

@interface LCRechargeBankTableViewCell ()
@property (nonatomic , weak) UILabel *accountlabel;
@property (nonatomic , weak) UILabel *namelabel;
@property (nonatomic , weak) UILabel *typelabel;
@end
@implementation LCRechargeBankTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *tipView = [[UIView alloc]initWithFrame:CGRectZero];
        
        [self.contentView addSubview:tipView];
        [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.top.equalTo(kUI_Width(10));
            make.height.equalTo(kUI_Width(16));
            make.right.equalTo(0);
            
        }];
        UIImageView *imgView = [[UIImageView alloc]initWithImage:image(@"icon_rechargeTipAcessImg")];
        [tipView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.width.equalTo(kUI_Width(4));
            make.height.equalTo(kUI_Width(16));
            make.top.equalTo(0);
        }];
        UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        tipLabel.text =  KLanguage(@"帐号");
        tipLabel.textColor = Color(@"#333333");
        tipLabel.font = BoldFont(16);
        [tipView addSubview:tipLabel];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imgView.mas_right).offset(kUI_Width(4));
            make.height.equalTo(kUI_Width(16));
            make.top.equalTo(0);
            make.right.equalTo(-kUI_Width(16));
        }];
        UIView *accountBgImgView = [[UIView alloc]initWithFrame:CGRectZero];
        accountBgImgView.backgroundColor = Color(@"#FFFFFF");
        [self.contentView addSubview:accountBgImgView];
        accountBgImgView.layer.cornerRadius = 4;
        accountBgImgView.layer.shadowColor = Color(@"#FFD5E7").CGColor;
        accountBgImgView.layer.shadowOffset = CGSizeMake(0,1);
        accountBgImgView.layer.shadowOpacity = 1;
        accountBgImgView.layer.shadowRadius = 1;
        [accountBgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.right.equalTo(-kUI_Width(12));
            make.height.equalTo(kUI_Width(36));
            make.top.mas_equalTo(tipView.mas_bottom).offset(kUI_Width(10));
        }];
        UILabel *accountLabel = [[UILabel alloc]init];
        accountLabel.font = RegularFont(14);
        accountLabel.textColor = Color(@"#666666");
//        accountLabel.numberOfLines = 0;
        [accountBgImgView addSubview:accountLabel];
        _accountlabel = accountLabel;
        
        UIButton *accCopyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        accCopyBtn.tag = 200;
        accCopyBtn.backgroundColor = Color(@"#F2F2F2");
        accCopyBtn.layer.cornerRadius = kUI_Width(4);
        [accCopyBtn setTitle:KLanguage(@"复制")  forState:UIControlStateNormal];
        [accCopyBtn setTitleColor:Color(@"#666666") forState:UIControlStateNormal];
        accCopyBtn.titleLabel.font = RegularFont(14);
        
        [accountBgImgView addSubview:accCopyBtn];
        [accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.right.mas_equalTo(accCopyBtn.mas_right).offset(-kUI_Width(10));
            make.centerY.equalTo(0);
            make.height.equalTo(kUI_Width(14));
        }];
        [accCopyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-kUI_Width(12));
            make.height.equalTo(kUI_Width(20));
            make.width.equalTo(kUI_Width(39));
            make.centerY.equalTo(0);
        }];
        [accCopyBtn addTarget:self action:@selector(copyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIView *nameTipView = [[UIView alloc]initWithFrame:CGRectZero];
        
        [self.contentView addSubview:nameTipView];
        [nameTipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.top.mas_equalTo(accountBgImgView.mas_bottom).offset(kUI_Width(10));
            make.height.equalTo(kUI_Width(16));
            make.right.equalTo(0);
            
        }];
        UIImageView *nameImgView = [[UIImageView alloc]initWithImage:image(@"icon_rechargeTipAcessImg")];
        [nameTipView addSubview:nameImgView];
        [nameImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.width.equalTo(kUI_Width(4));
            make.height.equalTo(kUI_Width(16));
            make.top.equalTo(0);
        }];
        UILabel *nameTipLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        nameTipLabel.text =  KLanguage(@"姓名");
        nameTipLabel.textColor = Color(@"#333333");
        nameTipLabel.font = BoldFont(16);
        [nameTipView addSubview:nameTipLabel];
        [nameTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(nameImgView.mas_right).offset(kUI_Width(4));
            make.height.equalTo(kUI_Width(16));
            make.top.equalTo(0);
            make.right.equalTo(-kUI_Width(16));
        }];
        UIView *nameBgView = [[UIView alloc]initWithFrame:CGRectZero];
        nameBgView.backgroundColor = Color(@"#FFFFFF");
        [self.contentView addSubview:nameBgView];
        nameBgView.layer.cornerRadius = 4;
        nameBgView.layer.shadowColor = Color(@"#FFD5E7").CGColor;
        nameBgView.layer.shadowOffset = CGSizeMake(0,1);
        nameBgView.layer.shadowOpacity = 1;
        nameBgView.layer.shadowRadius = 1;
        [nameBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.right.equalTo(-kUI_Width(12));
            make.height.equalTo(kUI_Width(36));
            make.top.mas_equalTo(nameTipView.mas_bottom).offset(kUI_Width(10));
        }];
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.font = RegularFont(14);
        nameLabel.textColor = Color(@"#666666");
//        accountLabel.numberOfLines = 0;
        [nameBgView addSubview:nameLabel];
        _namelabel = nameLabel;
        
        UIButton *nameCopyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        nameCopyBtn.tag = 201;
        nameCopyBtn.backgroundColor = Color(@"#F2F2F2");
        nameCopyBtn.layer.cornerRadius = kUI_Width(4);
        [nameCopyBtn setTitle:KLanguage(@"复制")  forState:UIControlStateNormal];
        [nameCopyBtn setTitleColor:Color(@"#666666") forState:UIControlStateNormal];
        nameCopyBtn.titleLabel.font = RegularFont(14);
        
        [nameBgView addSubview:nameCopyBtn];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.right.mas_equalTo(nameCopyBtn.mas_right).offset(-kUI_Width(10));
            make.centerY.equalTo(0);
            make.height.equalTo(kUI_Width(14));
        }];
        [nameCopyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-kUI_Width(12));
            make.height.equalTo(kUI_Width(20));
            make.width.equalTo(kUI_Width(39));
            make.centerY.equalTo(0);
        }];
        [nameCopyBtn addTarget:self action:@selector(copyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *typeTipView = [[UIView alloc]initWithFrame:CGRectZero];
        
        [self.contentView addSubview:typeTipView];
        [typeTipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.top.mas_equalTo(nameBgView.mas_bottom).offset(kUI_Width(10));
            make.height.equalTo(kUI_Width(16));
            make.right.equalTo(0);
            
        }];
        UIImageView *typeImgView = [[UIImageView alloc]initWithImage:image(@"icon_rechargeTipAcessImg")];
        [typeTipView addSubview:typeImgView];
        [typeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.width.equalTo(kUI_Width(4));
            make.height.equalTo(kUI_Width(16));
            make.top.equalTo(0);
        }];
        UILabel *typeTipLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        typeTipLabel.text =  KLanguage(@"银行名称");
        typeTipLabel.textColor = Color(@"#333333");
        typeTipLabel.font = BoldFont(16);
        [typeTipView addSubview:typeTipLabel];
        [typeTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(typeImgView.mas_right).offset(kUI_Width(4));
            make.height.equalTo(kUI_Width(16));
            make.top.equalTo(0);
            make.right.equalTo(-kUI_Width(16));
        }];
        UIView *typeBgView = [[UIView alloc]initWithFrame:CGRectZero];
        typeBgView.backgroundColor = Color(@"#FFFFFF");
        [self.contentView addSubview:typeBgView];
        typeBgView.layer.cornerRadius = 4;
        typeBgView.layer.shadowColor = Color(@"#FFD5E7").CGColor;
        typeBgView.layer.shadowOffset = CGSizeMake(0,1);
        typeBgView.layer.shadowOpacity = 1;
        typeBgView.layer.shadowRadius = 1;
        [typeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.right.equalTo(-kUI_Width(12));
            make.height.equalTo(kUI_Width(36));
            make.top.mas_equalTo(typeTipView.mas_bottom).offset(kUI_Width(10));
        }];
        UILabel *typeLabel = [[UILabel alloc]init];
        typeLabel.font = RegularFont(14);
        typeLabel.textColor = Color(@"#666666");
//        accountLabel.numberOfLines = 0;
        [typeBgView addSubview:typeLabel];
        _typelabel = typeLabel;
        
        UIButton *typeCopyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        typeCopyBtn.tag = 202;
        typeCopyBtn.backgroundColor = Color(@"#F2F2F2");
        typeCopyBtn.layer.cornerRadius = kUI_Width(4);
        [typeCopyBtn setTitle:KLanguage(@"复制")  forState:UIControlStateNormal];
        [typeCopyBtn setTitleColor:Color(@"#666666") forState:UIControlStateNormal];
        typeCopyBtn.titleLabel.font = RegularFont(14);
        
        [typeBgView addSubview:typeCopyBtn];
        [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.right.mas_equalTo(nameCopyBtn.mas_right).offset(-kUI_Width(10));
            make.centerY.equalTo(0);
            make.height.equalTo(kUI_Width(14));
        }];
        [typeCopyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-kUI_Width(12));
            make.height.equalTo(kUI_Width(20));
            make.width.equalTo(kUI_Width(39));
            make.centerY.equalTo(0);
        }];
        [typeCopyBtn addTarget:self action:@selector(copyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [submitBtn setBackgroundImage:image(@"icon_logoutBtnBg") forState:UIControlStateNormal];
        [submitBtn setTitle:KLanguage(@"我已转账") forState:UIControlStateNormal];
        
        [submitBtn setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
        submitBtn.titleLabel.font = BoldFont(18);
        [self.contentView addSubview:submitBtn];
        
        [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(kUI_Width(205));
            make.height.equalTo(kUI_Width(40));
            make.centerX.equalTo(0);
            make.top.mas_equalTo(typeBgView.mas_bottom).offset(kUI_Width(30));
            make.bottom.equalTo(-kUI_Width(10));
        }];
        [submitBtn addTarget:self action:@selector(submitButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
- (void)setDataModel:(LCRechargeConnetPersonModel *)dataModel{
    _dataModel = dataModel;
    _accountlabel.text = _dataModel.bankno;
    _namelabel.text = _dataModel.name;
    _typelabel.text = _dataModel.bankare;
}

- (void)copyBtnClicked:(UIButton *)btn{
    if (btn.tag == 200) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            [pasteboard setString:[[self accountlabel]text]];
        [SVProgressHUD showNoMaskViewWithInfo:KLanguage(@"已复制成功") ];
    }else if (btn.tag == 201){
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            [pasteboard setString:[[self namelabel]text]];
        [SVProgressHUD showNoMaskViewWithInfo:KLanguage(@"已复制成功") ];
    }else{
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            [pasteboard setString:[[self typelabel]text]];
        [SVProgressHUD showNoMaskViewWithInfo:KLanguage(@"已复制成功") ];
    }
        
        
    
}


- (void)submitButtonClicked{
    
    if (self.submitBlock) {
        self.submitBlock();
    }
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
