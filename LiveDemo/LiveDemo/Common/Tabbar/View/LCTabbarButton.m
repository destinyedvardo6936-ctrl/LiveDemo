//
//  LDTabbarButton.m
//  LDHeadlines
//
//  Created by mrgao on 2019/12/4.
//  Copyright © 2019 personal. All rights reserved.
//

#import "LCTabbarButton.h"
#import "UIButton+LCDelayTimeClicked.h"

@interface LCTabbarButton ()
@property (nonatomic, weak) UIButton *backButton;
@property (nonatomic, weak) UIImageView *normalImgView;
@property (nonatomic, weak) UIImageView *selectedImgView;
@property (nonatomic, weak) UILabel *titleLabel;
@end

@implementation LCTabbarButton

- (instancetype)initWithFrame:(CGRect)frame
                  normalImage:(UIImage *)normalImg
                  selectImage:(UIImage *)selectImage
                        title:(NSString *)title
                    imageSize:(CGSize)imageSize {
    self = [super initWithFrame:frame];

    if (self) {
        [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
        [self.normalImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(imageSize.height > kUI_Width(26) ? kUI_Width(2) : kUI_Width(4));
            make.centerX.equalTo(0);
            make.size.mas_equalTo(imageSize);
        }];
        [self.selectedImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(imageSize.height > kUI_Width(26) ? kUI_Width(2) : kUI_Width(4));
            make.centerX.equalTo(0);
            make.size.mas_equalTo(imageSize);
        }];

        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kUI_Width(11));
            make.left.right.equalTo(0);
            make.top.equalTo(self.normalImgView.mas_bottom).offset(kUI_Width(2));
        }];
        self.titleLabel.text = title;

        if (!title.length) {
            self.titleLabel.hidden = YES;
        }

        self.normalImgView.image = normalImg;
        self.selectedImgView.image = selectImage;
        self.selectedImgView.hidden = YES;
    }

    return self;
}

- (void)setTitle:(NSString *)title {
    _title = [title copy];
    self.titleLabel.text = title;
}

- (void)makeImgViewSelected:(BOOL)isSelected {
    [self makeImgViewSelected:isSelected animated:NO];
}

- (void)makeImgViewSelected:(BOOL)isSelected animated:(BOOL)animated {
    if (!animated) {
        _isSelected = isSelected;
        self.normalImgView.hidden = isSelected;
        self.selectedImgView.hidden = !isSelected;

        self.titleLabel.font = RegularFont(11);
        self.titleLabel.textColor = self.isSelected ? Color(@"#FC6EA1") : Color(@"#646464");
    } else {
        if (self.isAnimation) {
            [self.titleLabel.layer removeAllAnimations];
            self.titleLabel.font = RegularFont(11);
            self.titleLabel.textColor = self.isSelected ? Color(@"#FC6EA1") : Color(@"#646464");
        }

        _isSelected = isSelected;
        _isAnimation = YES;
        self.userInteractionEnabled = NO;
        self.selectedImgView.hidden = NO;
        self.selectedImgView.transform = CGAffineTransformMakeScale(0.1, 0.1);

        [UIView animateWithDuration:0.3
                         animations:^{
            self.normalImgView.transform = CGAffineTransformMakeScale(0.1, 0.1);
            self.selectedImgView.transform = CGAffineTransformMakeScale(1.2, 1.2);
        }
                         completion:^(BOOL finished) {
            if (finished) {
                if (self.isSelected) {
                    self.normalImgView.transform = CGAffineTransformIdentity;
                    self.normalImgView.hidden = YES;
                    [UIView animateWithDuration:0.3
                                     animations:^{
                        self.selectedImgView.transform = CGAffineTransformIdentity;
                    }
                                     completion:^(BOOL finished) {
                        self->_isAnimation = NO;
                    }];
                } else {
                    self.normalImgView.transform = CGAffineTransformIdentity;
                    self.normalImgView.hidden = NO;
                    self.selectedImgView.hidden = YES;
                    self.titleLabel.hidden = NO;
                }
            }
        }];

        [UIView animateWithDuration:0.6
                         animations:^{
            self.titleLabel.font = RegularFont(11);
            self.titleLabel.textColor = self.isSelected ? Color(@"#FC6EA1") : Color(@"#646464");
        }
                         completion:^(BOOL finished) {
            self.userInteractionEnabled = YES;
        }];
    }
}

- (void)butttonClicked {
    if (self.tabSelectedBlock) {
        self.tabSelectedBlock(self);
    }
}

- (UIButton *)backButton {
    if (_backButton == nil) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton = button;
        [self addSubview:_backButton];
        [_backButton addTarget:self action:@selector(butttonClicked) forControlEvents:UIControlEventTouchUpInside];
        WS(weakSelf)
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            if (weakSelf.refreshBlock) {
                weakSelf.refreshBlock();
            }
        }];
        tap.numberOfTapsRequired = 2;
        [_backButton addGestureRecognizer:tap];
    }

    return _backButton;
}

- (UIImageView *)normalImgView {
    if (_normalImgView == nil) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _normalImgView = imageView;
        _normalImgView.contentMode = UIViewContentModeScaleAspectFit;
        [self.backButton addSubview:_normalImgView];
    }

    return _normalImgView;
}

- (UIImageView *)selectedImgView {
    if (_selectedImgView == nil) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _selectedImgView = imageView;
        _selectedImgView.contentMode = UIViewContentModeScaleAspectFit;
        [self.backButton addSubview:_selectedImgView];
    }

    return _selectedImgView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel = label;
        _titleLabel.font = RegularFont(11);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = Color(@"#646464");
        [self.backButton addSubview:_titleLabel];
    }

    return _titleLabel;
}

@end
