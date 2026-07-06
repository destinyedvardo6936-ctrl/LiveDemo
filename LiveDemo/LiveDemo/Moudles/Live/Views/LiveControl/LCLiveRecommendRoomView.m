//
//  LCLiveRecommendRoomView.m
//  LiveDemo
//
//  Created by mrgao on 2022/12/3.
//

#import "LCLiveRecommendRoomView.h"
#import "LCLiveRecommedRoomCell.h"
@interface LCLiveRecommendRoomView ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic , weak) UIView *contentView;
@property (nonatomic , weak) LCBaseTableView *mainTableView;
@property (nonatomic , weak) UILabel *tipLabel;
@property (nonatomic , weak) UIActivityIndicatorView *loadingView;
@property (nonatomic , weak) UILabel *noDataLabel;

@end
@implementation LCLiveRecommendRoomView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_right);
            make.top.equalTo(0);
            make.bottom.equalTo(0);
            make.width.equalTo(kUI_Width(134));
        }];
        [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(kStatusBarHeight + kUI_Width(22));
            make.left.equalTo(kUI_Width(12));
            make.height.equalTo(kUI_Width(12));
            make.right.equalTo(-kUI_Width(12));
        }];
        [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(-kUI_Width(12)/2.0 - kUI_Width(5)/2.0);
            make.centerX.equalTo(0);
            make.height.width.equalTo(kUI_Width(30));
            
        }];
        [self.noDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.loadingView.mas_bottom).offset(kUI_Width(5));
            make.centerX.equalTo(0);
            make.left.equalTo(kUI_Width(12));
            make.right.equalTo(-kUI_Width(12));
        }];
        [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.right.equalTo(-kUI_Width(12));
            make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(kUI_Width(12));
            make.bottom.equalTo(0);
        }];
        self.mainTableView.hidden = YES;
        [self.loadingView startAnimating];
        WS(weakSelf)
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id _Nonnull sender) {
            [weakSelf hiddenFromSuperView];
        }];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        UISwipeGestureRecognizer *swipe1 = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDidScroll:)];
        swipe1.numberOfTouchesRequired = 1;
//        swipe1.delegate = self;
//        swipe1.cancelsTouchesInView = YES;
        swipe1.direction = UISwipeGestureRecognizerDirectionRight;

        [self addGestureRecognizer:swipe1];
    }
    return self;
}
- (void)swipeDidScroll:(UISwipeGestureRecognizer *)swipe {
//    LCLog(@"%ld",(long)swipe.state);
    
        [self hiddenFromSuperView];
    

//    if(swipe.state == UIGestureRecognizerStateBegan ){
//    LCLog(@"2221212");
//        CGPoint point = [swipe locationInView:swipe.view];
//        LCLog(@"清扫位置%@",NSStringFromCGPoint(point));
//    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:self.contentView]) {
    
        return NO;
    }
    
    return YES;
}
- (void)show{
    [UIView animateWithDuration:0.5
                     animations:^{
        self.contentView.transform = CGAffineTransformMakeTranslation(-kUI_Width(134), 0);
    }
                     completion:^(BOOL finished) {
        
    }];
}
- (void)hiddenFromSuperView{
    [UIView animateWithDuration:0.5
                     animations:^{
        self.contentView.transform = CGAffineTransformIdentity;
    }
                     completion:^(BOOL finished) {
        if(self.dismissBlock){
            self.dismissBlock();
        }
        [self removeFromSuperview];
    }];
    
}
- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    if(_dataArray.count){
        [self.loadingView stopAnimating];
        self.loadingView.hidden = YES;
        self.noDataLabel.text = KLanguage(@"正在加载");
        self.noDataLabel.hidden = YES;
        self.mainTableView.hidden = NO;
        [self.mainTableView reloadData];
    }else{
        [self.loadingView stopAnimating];
        self.loadingView.hidden = YES;
        self.noDataLabel.text = KLanguage(@"暂无数据");
        self.noDataLabel.hidden = NO;
        self.mainTableView.hidden = YES;
        [self.mainTableView reloadData];
    }
    
}
#pragma mark----UITableViewDelegate-----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.000000001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return kUI_Width(8);
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return tableView.width;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.width, kUI_Width(8))];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LCLiveRecommedRoomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCLiveRecommedRoomCell"];
    cell.dataModel = self.dataArray[indexPath.section];
    cell.backgroundColor = tableView.backgroundColor;
    cell.contentView.backgroundColor = tableView.backgroundColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.selectOtherRoomBlock) {
        self.selectOtherRoomBlock(self.dataArray, self.dataArray[indexPath.section]);
    }
    [self hiddenFromSuperView];
}
#pragma mark---- 懒加载 ----
- (UIView *)contentView {
    if (!_contentView) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        [self addSubview:view];
//        view.layer.cornerRadius = kUI_Width(16);
        view.backgroundColor = ColorAlpha(@"#000000", 0.8);
        _contentView = view;
        _contentView.clipsToBounds = YES;
    }

    return _contentView;
}

- (UILabel *)tipLabel{
    if (_tipLabel == nil){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = RegularFont(12);
        label.text = KLanguage(@"为您推荐");
        label.textColor = Color(@"#FFFFFF ");
        [self.contentView addSubview:label];
        _tipLabel = label;
        
    }
    return _tipLabel;
}
- (UIActivityIndicatorView *)loadingView{
    if(!_loadingView){
        UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
        [self.contentView addSubview:view];
        _loadingView = view;
    }
    return _loadingView;
}
- (UILabel *)noDataLabel{
    if (_noDataLabel == nil){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = RegularFont(12);
        label.text = KLanguage(@"正在加载");
        label.textColor = Color(@"#FFFFFF ");
        label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label];
        _noDataLabel = label;
        
    }
    return _noDataLabel;
}
- (LCBaseTableView *)mainTableView{
    if (_mainTableView == nil){
        LCBaseTableView *tableView = [LCBaseTableView addTableGrouped];
        _mainTableView = tableView;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.dataSource = self;
        _mainTableView.delegate = self;
        _mainTableView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_mainTableView];
        [_mainTableView registerClass:[LCLiveRecommedRoomCell class] forCellReuseIdentifier:@"LCLiveRecommedRoomCell"];
        
    }
    return _mainTableView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
