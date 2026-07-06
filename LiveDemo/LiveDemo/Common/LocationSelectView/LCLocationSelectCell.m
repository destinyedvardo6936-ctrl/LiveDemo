//
//  LCLocationSelectCell.m
//  LiveDemo
//
//  Created by mrgao on 2022/11/24.
//

#import "LCLocationSelectCell.h"

@interface LCLocationSelectCell ()
@property (nonatomic , weak) UILabel *mainLabel;
@end
@implementation LCLocationSelectCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.mainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
    }
    return self;
}
#pragma mark---- 懒加载 ----
- (UILabel *)mainLabel{
    if (_mainLabel == nil){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.textColor = Color(@"#333333");
        label.font = RegularFont(12);
        [self.contentView addSubview:label];
        _mainLabel = label;
        _mainLabel.backgroundColor = Color(@"#EEEEEE");
        _mainLabel.clipsToBounds = YES;
        _mainLabel.layer.cornerRadius = kUI_Width(28)/2.0;
    }
    return _mainLabel;
}
@end
