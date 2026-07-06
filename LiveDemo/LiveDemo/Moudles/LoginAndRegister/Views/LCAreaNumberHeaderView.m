//
//  LCAreaNumberHeaderView.m
//  LiveDemo
//
//  Created by mrgao on 2023/1/31.
//

#import "LCAreaNumberHeaderView.h"

@interface LCAreaNumberHeaderView ()
@property (nonatomic , weak) UILabel *mainLabel;
@end
@implementation LCAreaNumberHeaderView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {

        [self.mainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(kViewMargin));
            make.centerY.equalTo(0);
            make.right.equalTo(-kUI_Width(34));
            make.height.equalTo(kUI_Width(14));
        }];
    }
    return self;
}
- (void)setTitleStr:(NSString *)titleStr{
    _titleStr = [titleStr copy];
    self.mainLabel.text = _titleStr;
}
#pragma mark---- 懒加载 ----
- (UILabel *)mainLabel{
    if(_mainLabel == nil){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.textColor = Color(@"#666666");
        label.font = BoldFont(14);
        [self.contentView addSubview:label];
        _mainLabel = label;
    }
    return _mainLabel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
