//
//  LCVersionUpdateView.m
//  LCHeadlines
//
//  Created by mrgao on 2020/2/7.
//  Copyright © 2020 WY. All rights reserved.
//

#import "LCVersionUpdateView.h"

@interface LCVersionUpdateView ()
@property (nonatomic,weak)UIImageView *backgroundImgView;
@property (nonatomic,weak)UILabel *tipLabel;
@property (nonatomic,weak)UIView *lineView;
@property (nonatomic,weak)UILabel *versionLabel;
@property (nonatomic,weak)UILabel *contentLabel;
@property (nonatomic,weak)UIButton *downloadButton;
@property (nonatomic,weak)UIButton *closeButton;
@end
@implementation LCVersionUpdateView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = ColorAlpha(@"#000000", 0.5);
        [self.backgroundImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(0);
            make.width.equalTo(kUI_Width(280));
            make.height.equalTo(kUI_Width(kUI_Width(423)));
        }];
        [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(kUI_Width(173));
            make.centerX.equalTo(0);
            make.height.equalTo(kUI_Width(26));
        }];
       
        [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(kUI_Width(10));
            make.left.equalTo(kUI_Width(28));
            make.height.equalTo(kUI_Width(20));
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                   make.height.equalTo(kUI_Width(1));
                    make.left.equalTo(kUI_Width(30));
                              make.right.equalTo(-kUI_Width(30));
            make.top.mas_equalTo(self.versionLabel.mas_bottom).offset(kUI_Width(1));
               }];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.versionLabel.mas_bottom).offset(kUI_Width(20));
            make.left.equalTo(kUI_Width(30));
            make.right.equalTo(-kUI_Width(30));
           
        }];
        [self.downloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(-kUI_Width(30));
            make.centerX.equalTo(0);
            make.height.equalTo(kUI_Width(32));
            make.width.equalTo(kUI_Width(127));
        }];
        [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.backgroundImgView.mas_bottom).offset(kUI_Width(29));
            make.centerX.equalTo(0);
            make.width.height.equalTo(kUI_Width(30));
        }];
    }
    return self;
}
- (void)downloadBtnClick:(UIButton *)btn{
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/id1491856294?mt=8"]];
}
- (void)closeBtnClick:(UIButton *)btn{
//    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] dictionaryForKey:versionUpdateSafePath];
//   NSString *app_Version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    if ([dic.allKeys containsObject:app_Version]) {
//        NSMutableDictionary *temp = dic!=nil ? [NSMutableDictionary dictionaryWithDictionary:dic] :[NSMutableDictionary dictionary];
//        [temp setObject:@{self.dataModel.newestVersion:@(YES)} forKey:app_Version];
//        [[NSUserDefaults standardUserDefaults] setObject:temp.copy forKey:versionUpdateSafePath];
//        
//    }else{
//        NSMutableDictionary *temp = dic!=nil ? [NSMutableDictionary dictionaryWithDictionary:dic] :[NSMutableDictionary dictionary];
//        [temp setObject:@{self.dataModel.newestVersion:@(YES)} forKey:app_Version];
//        [[NSUserDefaults standardUserDefaults] setObject:temp.copy forKey:versionUpdateSafePath];
//    }
        [self removeFromSuperview];
    
   
}
//- (void)setDataModel:(LCVersionUpdateModel *)dataModel{
//    _dataModel = dataModel;
//    self.versionLabel.text = _dataModel.newestVersion;
//    self.contentLabel.text = _dataModel.updateInfo;
//
//    
//}
#pragma mark----懒加载----
- (UIImageView *)backgroundImgView{
    if (_backgroundImgView == nil) {
        UIImageView *imgView = [[UIImageView alloc]initWithImage:image(@"bg_shengji")];
        _backgroundImgView = imgView;
        _backgroundImgView.userInteractionEnabled = YES;
        [self addSubview:_backgroundImgView];
    }
    return _backgroundImgView;
}

- (UILabel *)tipLabel{
    if (_tipLabel == nil) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        _tipLabel = label;
        _tipLabel.text = @"发现新版本";
        _tipLabel.font = BoldFont(18);
        _tipLabel.textColor = Color(@"#000000");
        [self.backgroundImgView addSubview:_tipLabel];
    }
    return _tipLabel;
}
- (UIView *)lineView{
    if (_lineView == nil) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        _lineView = view;
        _lineView.backgroundColor = Color(@"#F4F6FB");
        [self.backgroundImgView addSubview:_lineView];
    }
    return _lineView;
}
- (UILabel *)versionLabel{
    if (_versionLabel == nil) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        _versionLabel = label;
//        _versionLabel.text = @"发现新版本";
        _versionLabel.font = BoldFont(16);
        _versionLabel.textColor = Color(@"#000000");
        [self.backgroundImgView addSubview:_versionLabel];
    }
    return _versionLabel;
}
- (UILabel *)contentLabel{
    if (_contentLabel == nil) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        _contentLabel = label;
//        _contentLabel.text = @"发现新版本";
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = RegularFont(14);
        _contentLabel.textColor = Color(@"#293753");
        [self.backgroundImgView addSubview:_contentLabel];
    }
    return _contentLabel;
}
- (UIButton *)downloadButton{
    if (_downloadButton == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _downloadButton = btn;
        [_downloadButton setTitle:@"立即下载" forState:UIControlStateNormal];
        [_downloadButton setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
        _downloadButton.titleLabel.font = RegularFont(14);
        _downloadButton.backgroundColor = Color(@"#0064FF");
        _downloadButton.layer.cornerRadius = kUI_Width(16);
        [self.backgroundImgView addSubview:_downloadButton];
        [_downloadButton addTarget:self action:@selector(downloadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downloadButton;
}
- (UIButton *)closeButton{
    if (_closeButton == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton = btn;
        [_closeButton setImage:image(@"ic_guanbishengji") forState:UIControlStateNormal];
        [self addSubview:_closeButton];
        [_closeButton addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
