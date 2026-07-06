//
//  LCSearchResultHeaderView.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/2.
//

#import "LCSearchResultHeaderView.h"

@interface LCSearchResultHeaderView ()
@property (nonatomic , weak) UILabel *mainLabel;
@end
@implementation LCSearchResultHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame: frame];
    if (self){
       
        [self.mainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(kUI_Width(10));
            make.height.equalTo(kUI_Width(16));
            make.left.equalTo(kUI_Width(kViewMargin));
            make.right.equalTo(-kUI_Width(kViewMargin));
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
    if (!_mainLabel){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = BoldFont(16);
        label.textColor = Color(@"#333333");
        _mainLabel = label;
        [self addSubview:_mainLabel];
    }
    return _mainLabel;
}

@end
