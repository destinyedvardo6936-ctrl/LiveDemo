//
//  jubaoVC.m
//  iphoneLive
//
//  Created by Boom on 2017/7/14.
//  Copyright © 2017年 cat. All rights reserved.
//

#import "jubaoVC.h"
#import "jubaoCell.h"
@interface jubaoVC ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>{
    
    
    NSDictionary *selctDic;
    NSInteger selctCount;
    UITextView *jubaoTextView;
    CGFloat textHeight;
    UILabel *placeLabel;
    UILabel *headerLabel;
    
    UIColor *bg_corlor;
    UIView *bottomInputView;
}

@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)UITableView *table;
@end

@implementation jubaoVC

-(void)doReturn{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requetData];

    //关闭IQKeyboard
//    [IQKeyboardManager sharedManager].enable = NO;
//    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr = [NSMutableArray array];
    [self.navView setLeftButtonType:LCBaseNavigationViewLeftType_BlackBack];
    [self.navView setCenterLabelFont:BoldFont(18)];
    [self.navView setCenterLabelTextColor:Color(@"#333333")];
    [self.navView setCenterLabelText:KLanguage(@"举报")];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(0);
        make.height.equalTo(kNavBarHeight);
    }];
    bg_corlor = ColorAlpha(@"#f4f5f6", 1);
    _table = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-64-kStatusBarHeight-KSafeHeight) style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.backgroundColor = bg_corlor;//RGB(240, 240, 240);
    selctCount = 100000;
    textHeight = 0.0;
    self.view.backgroundColor = bg_corlor;
    [self.view addSubview:_table];
    
    //键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
- (void)requetData{
    
    NSString *url;
    if (_isLive) {
        url = @"Live.getReportClass";
    }else{
        url = @"Video.getReportContentlist";
    }
    WS(weakSelf);
    [[LCNetWorkManager manager] requestUrl:url method:@"POST" params:nil success:^(id  _Nullable result) {
        weakSelf.dataArr = [NSMutableArray array];
        NSArray *info = [result valueForKey:@"info"];
        weakSelf.dataArr = [NSMutableArray arrayWithArray:info];
        [weakSelf.table reloadData];
    } failure:^(NSError * _Nullable error) {
        
    }];
    
    

}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (!headerLabel) {
        headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        headerLabel.text = KLanguage(@"   选择举报的理由");
        headerLabel.textColor = ColorAlpha(@"#959697", 1);
        headerLabel.font = [UIFont systemFontOfSize:13];
        headerLabel.backgroundColor = ColorAlpha(@"#f4f5f6", 1);
    }
    return headerLabel;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (!bottomInputView) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80+110)];
        view.backgroundColor = bg_corlor;//_table.backgroundColor;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 30)];
        label.textColor = ColorAlpha(@"#959697", 1);
        label.text = KLanguage(@"更多详细信息请在说明框中描述（选填）");
        label.font = [UIFont systemFontOfSize:13];
        [view addSubview:label];
        jubaoTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, label.bottom, SCREEN_WIDTH-20,90)];
        jubaoTextView.delegate = self;
        jubaoTextView.layer.masksToBounds = YES;
        jubaoTextView.layer.cornerRadius = 5.0;
        
        jubaoTextView.font = LightFont(13);
        jubaoTextView.textColor = ColorAlpha(@"#333333", 1);//ColorAlpha(@"#333333", 1);
        jubaoTextView.backgroundColor = [UIColor whiteColor];
        [view addSubview:jubaoTextView];
        placeLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 120, 15)];
        placeLabel.font = LightFont(12);
        placeLabel.textColor = ColorAlpha(@"#999999", 1);
    //    placeLabel.text = @"输入举报理由";
        [jubaoTextView addSubview:placeLabel];
        UIButton *btn = [UIButton buttonWithType:0];
        btn.frame = CGRectMake(20, jubaoTextView.bottom+10, SCREEN_WIDTH-40, 40);
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 20.0;
        [btn setBackgroundColor:normalColors];
        [btn setTitle:KLanguage(@"提交") forState:0];
        
        [btn addTarget:self action:@selector(dojubao) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        bottomInputView = view;
    }
    return bottomInputView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 80+110;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    jubaoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"jubaoCell"];
    cell.backgroundColor = ColorAlpha(@"#f4f5f6",1);
    if (!cell) {
        cell = [[jubaoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"jubaoCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.leftLabel.text = [_dataArr[indexPath.row] valueForKey:@"name"];
    if (indexPath.row == selctCount) {
        cell.rightImage.image = [UIImage imageNamed:@"profit_sel"];//ask_jubao2
    }else{
        cell.rightImage.image = [UIImage imageNamed:@"profit_nor"];//ask_jubao1
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self hideKeboard];
    selctDic = [NSDictionary dictionaryWithDictionary:_dataArr[indexPath.row]];
    selctCount = indexPath.row;
    [_table reloadData];
}
- (void)dojubao{
    [self hideKeboard];
    if (selctCount == 100000) {
        [SVProgressHUD showMaskViewWithFailure:KLanguage(@"请选择举报理由")];
        return;
    }
    NSString *content = [NSString stringWithFormat:@"%@ %@",minstr([selctDic valueForKey:@"name"]),jubaoTextView.text];
    
    
    NSString *url;
    NSDictionary *parameterDic;


    if (_isLive) {
        url = @"Live.setReport";
        parameterDic = @{
                                  
                                   @"touid":_dongtaiId,
                                  
                                   @"content":content,
                                   };
    }else{
        url = @"Video.report";
        parameterDic = @{
                        
                         @"videoid":_dongtaiId,
                        
                         @"content":content,
                         };
    }
    [[LCNetWorkManager manager] requestUrl:url method:@"POST" params:parameterDic success:^(id  _Nullable result) {
        [SVProgressHUD showMaskViewWithFailure:KLanguage(@"举报成功")];
        [UIView animateWithDuration:0.5 animations:^{
            [self doReturn];
        }];
    } failure:^(NSError * _Nullable error) {
        [SVProgressHUD showMaskViewWithFailure:error.domain];
    }];
    
   
    

}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (![text isEqualToString:@""]) {
        placeLabel.hidden = YES;
    }
    
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1) {
        placeLabel.hidden = NO;
    }
    

    return YES;
}
- (void)hideKeboard{
    [jubaoTextView resignFirstResponder];
}
#pragma mark -- 获取键盘高度
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
//    CGFloat height = keyboardRect.origin.y;
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0.0f, -keyboardRect.size.height, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
}
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame =CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [jubaoTextView resignFirstResponder];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
