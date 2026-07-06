//
//  LCNoDataTableViewCell.m
//  LiveDemo
//
//  Created by mrgao on 2023/3/17.
//

#import "LCNoDataTableViewCell.h"
#import "LCNoDataView.h"

@interface LCNoDataTableViewCell ()
@property (nonatomic , weak) LCNoDataView *mainView;
@end
@implementation LCNoDataTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        LCNoDataView *emptyView = [[LCNoDataView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:emptyView];
        _mainView = emptyView;
        [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
//        emptyView.title = KLanguage(@"主播在赶来的路上~");
////        emptyView.backgroundColor = self.contentView.backgroundColor;
//        emptyView.customImageFrame = CGRectMake((SCREEN_WIDTH - kUI_Width(157))/2.0, kUI_Width(40), kUI_Width(157), kUI_Width(157));
//        [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.bottom.right.equalTo(0);
//        }];
    }
    return self;
}
- (void)setTitleStr:(NSString *)titleStr{
    _titleStr = [titleStr copy];
    self.mainView.title = _titleStr;
}
- (void)setImgStr:(NSString *)imgStr{
    _imgStr = [imgStr copy];
    self.mainView.customImg = image(_imgStr);
}
- (void)setCustomImageFrame:(CGRect)customImageFrame{
    _customImageFrame = customImageFrame;
    self.mainView.customImageFrame = _customImageFrame;
}
- (void)setCustomTitleFrame:(CGRect)customTitleFrame{
    _customTitleFrame = customTitleFrame;
    self.mainView.customTitleFrame = _customTitleFrame;
}
- (void)setCustomBgColor:(UIColor *)customBgColor{
    _customBgColor = customBgColor;
    self.mainView.customBgColor = _customBgColor;
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
