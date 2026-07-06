//
//  LCTitleNoticeCell.m
//  LiveDemo
//
//  Created by mrgao on 2022/11/21.
//

#import "LCTitleNoticeCell.h"

@interface LCTitleNoticeCell ()
@property (nonatomic , weak) UILabel *titleLabel;
@end
@implementation LCTitleNoticeCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
    }
    return self;
}
- (void)setTitleStr:(NSString *)titleStr{
    _titleStr = [titleStr copy];
    self.titleLabel.text = _titleStr;
}
- (void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    self.titleLabel.textColor = _textColor ? _textColor : Color(@"#FFFFFF");
}
#pragma mark---- 懒加载 ----
- (UILabel *)titleLabel{
    if (_titleLabel == nil){
        UILabel *label = [[UILabel alloc] init];
        label.font = RegularFont(14);
        label.textColor = Color(@"#FFFFFF");
        [self.contentView addSubview:label];
        _titleLabel = label;
    }
    return _titleLabel;
}
@end
