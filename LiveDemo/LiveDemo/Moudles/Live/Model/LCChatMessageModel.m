//
//  LCChatMessageModel.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/18.
//

#import "LCChatMessageModel.h"

@implementation LCChatMessageModel
- (void)changeContentToAtttributeString{
    if(self.type == 1){
//        self.backgroundColor = ColorAlpha(@"#000000", 0.3);
        self.attContent = [[NSAttributedString alloc]initWithString:self.content attributes:@{NSForegroundColorAttributeName:Color(@"#86D9EF"),NSFontAttributeName:RegularFont(12)}];
    }else if (self.type == 2){
        NSTextAttachment *adminAttchment = [[NSTextAttachment alloc]init];
        adminAttchment.bounds = CGRectMake(0, 0, RegularFont(12).lineHeight *kUI_Width(17)/1.0/kUI_Width(12), RegularFont(12).lineHeight);
        adminAttchment.image = image(@"chat_admin");
        NSAttributedString *adminString = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(adminAttchment)];
        NSTextAttachment *shouAttchment = [[NSTextAttachment alloc]init];
        shouAttchment.bounds = CGRectMake(0, 0, RegularFont(12).lineHeight, RegularFont(12).lineHeight);
        shouAttchment.image = image(@"chat_shou_month");
        NSAttributedString *shouString = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(shouAttchment)];
        
        NSTextAttachment *yearAttchment = [[NSTextAttachment alloc]init];
        yearAttchment.bounds = CGRectMake(0, 0, RegularFont(12).lineHeight, RegularFont(12).lineHeight);
        yearAttchment.image = image(@"chat_shou_year");
        NSAttributedString *yearString = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(yearAttchment)];


        NSTextAttachment *vipAttchment = [[NSTextAttachment alloc]init];
        vipAttchment.bounds = CGRectMake(0, 0, RegularFont(12).lineHeight *2, RegularFont(12).lineHeight);//设置frame
        vipAttchment.image =image(@"chat_vip") ;
        NSAttributedString *vipString = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(vipAttchment)];
        NSTextAttachment *liangAttchment = [[NSTextAttachment alloc]init];
        liangAttchment.bounds = CGRectMake(0, 0, RegularFont(12).lineHeight *kUI_Width(16)/1.0/kUI_Width(12), RegularFont(12).lineHeight);
        liangAttchment.image = image(@"chat_liang");
        NSAttributedString *liangString = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(liangAttchment)];
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:self.uname attributes:@{NSFontAttributeName:RegularFont(12),NSForegroundColorAttributeName:Color(@"#86D9EF")}];
        [noteStr appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"：  %@",self.content] attributes:@{NSFontAttributeName:RegularFont(12),NSForegroundColorAttributeName:Color(@"#FFFFFF")}]];
        NSAttributedString *speaceString = [[NSAttributedString  alloc]initWithString:@" "];
    //    //插入靓号图标
        if (![self.liangname isEqual:@"0"] && ![self.liangname isEqual:@"(null)"] && self.liangname !=nil && self.liangname !=NULL) {
            [noteStr insertAttributedString:speaceString atIndex:0];//插入到第几个下标
            [noteStr insertAttributedString:liangString atIndex:0];//插入到第几个下标
        }
        //插入守护图标
        if ([self.guard_type intValue] == 1) {
            [noteStr insertAttributedString:speaceString atIndex:0];//插入到第几个下标
            [noteStr insertAttributedString:shouString atIndex:0];//插入到第几个下标
        }
        if ([self.guard_type intValue] == 2) {
            [noteStr insertAttributedString:speaceString atIndex:0];//插入到第几个下标
            [noteStr insertAttributedString:yearString atIndex:0];//插入到第几个下标
        }
        //插入管理图标
        if ([self.issuper integerValue] == 1) {
            [noteStr insertAttributedString:speaceString atIndex:0];//插入到第几个下标
            [noteStr insertAttributedString:adminString atIndex:0];//插入到第几个下标
        }
        //插入VIP图标
        if ([self.vip_type integerValue] == 1) {
            [noteStr insertAttributedString:speaceString atIndex:0];//插入到第几个下标
            [noteStr insertAttributedString:vipString atIndex:0];//插入到第几个下标
        }
        
        self.attContent = noteStr.copy;
    }else if (self.type == 3){
        NSTextAttachment *adminAttchment = [[NSTextAttachment alloc]init];
        adminAttchment.bounds = CGRectMake(0, 0, RegularFont(12).lineHeight *kUI_Width(17)/1.0/kUI_Width(12), RegularFont(12).lineHeight);
        adminAttchment.image = image(@"chat_admin");
        NSAttributedString *adminString = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(adminAttchment)];
        NSTextAttachment *shouAttchment = [[NSTextAttachment alloc]init];
        shouAttchment.bounds = CGRectMake(0, 0, RegularFont(12).lineHeight, RegularFont(12).lineHeight);
        shouAttchment.image = image(@"chat_shou_month");
        NSAttributedString *shouString = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(shouAttchment)];
        
        NSTextAttachment *yearAttchment = [[NSTextAttachment alloc]init];
        yearAttchment.bounds = CGRectMake(0, 0, RegularFont(12).lineHeight, RegularFont(12).lineHeight);
        yearAttchment.image = image(@"chat_shou_year");
        NSAttributedString *yearString = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(yearAttchment)];


        NSTextAttachment *vipAttchment = [[NSTextAttachment alloc]init];
        vipAttchment.bounds = CGRectMake(0, 0, RegularFont(12).lineHeight *2, RegularFont(12).lineHeight);//设置frame
        vipAttchment.image =image(@"chat_vip") ;
        NSAttributedString *vipString = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(vipAttchment)];
        NSTextAttachment *liangAttchment = [[NSTextAttachment alloc]init];
        liangAttchment.bounds = CGRectMake(0, 0, RegularFont(12).lineHeight *kUI_Width(16)/1.0/kUI_Width(12), RegularFont(12).lineHeight);
        liangAttchment.image = image(@"chat_liang");
        NSAttributedString *liangString = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(liangAttchment)];
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:self.uname attributes:@{NSFontAttributeName:RegularFont(12),NSForegroundColorAttributeName:Color(@"#86D9EF")}];
        [noteStr appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"：  %@",self.content] attributes:@{NSFontAttributeName:RegularFont(12),NSForegroundColorAttributeName:Color(@"#FFFFFF")}]];
        NSAttributedString *speaceString = [[NSAttributedString  alloc]initWithString:@" "];
    //    //插入靓号图标
        if (![self.liangname isEqual:@"0"] && ![self.liangname isEqual:@"(null)"] && self.liangname !=nil && self.liangname !=NULL) {
            [noteStr insertAttributedString:speaceString atIndex:0];//插入到第几个下标
            [noteStr insertAttributedString:liangString atIndex:0];//插入到第几个下标
        }
        //插入守护图标
        if ([self.guard_type intValue] == 1) {
            [noteStr insertAttributedString:speaceString atIndex:0];//插入到第几个下标
            [noteStr insertAttributedString:shouString atIndex:0];//插入到第几个下标
        }
        if ([self.guard_type intValue] == 2) {
            [noteStr insertAttributedString:speaceString atIndex:0];//插入到第几个下标
            [noteStr insertAttributedString:yearString atIndex:0];//插入到第几个下标
        }
        //插入管理图标
        if ([self.issuper integerValue] == 1) {
            [noteStr insertAttributedString:speaceString atIndex:0];//插入到第几个下标
            [noteStr insertAttributedString:adminString atIndex:0];//插入到第几个下标
        }
        //插入VIP图标
        if ([self.vip_type integerValue] == 1) {
            [noteStr insertAttributedString:speaceString atIndex:0];//插入到第几个下标
            [noteStr insertAttributedString:vipString atIndex:0];//插入到第几个下标
        }
        
        self.attContent = noteStr.copy;
    }else if (self.type == 5){
        NSTextAttachment *adminAttchment = [[NSTextAttachment alloc]init];
        adminAttchment.bounds = CGRectMake(0, 0, RegularFont(12).lineHeight *kUI_Width(17)/1.0/kUI_Width(12), RegularFont(12).lineHeight);
        adminAttchment.image = image(@"chat_admin");
        NSAttributedString *adminString = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(adminAttchment)];
        NSTextAttachment *shouAttchment = [[NSTextAttachment alloc]init];
        shouAttchment.bounds = CGRectMake(0, 0, RegularFont(12).lineHeight, RegularFont(12).lineHeight);
        shouAttchment.image = image(@"chat_shou_month");
        NSAttributedString *shouString = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(shouAttchment)];
        
        NSTextAttachment *yearAttchment = [[NSTextAttachment alloc]init];
        yearAttchment.bounds = CGRectMake(0, 0, RegularFont(12).lineHeight, RegularFont(12).lineHeight);
        yearAttchment.image = image(@"chat_shou_year");
        NSAttributedString *yearString = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(yearAttchment)];


        NSTextAttachment *vipAttchment = [[NSTextAttachment alloc]init];
        vipAttchment.bounds = CGRectMake(0, 0, RegularFont(12).lineHeight *2, RegularFont(12).lineHeight);//设置frame
        vipAttchment.image =image(@"chat_vip") ;
        NSAttributedString *vipString = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(vipAttchment)];
        NSTextAttachment *liangAttchment = [[NSTextAttachment alloc]init];
        liangAttchment.bounds = CGRectMake(0, 0, RegularFont(12).lineHeight *kUI_Width(16)/1.0/kUI_Width(12), RegularFont(12).lineHeight);
        liangAttchment.image = image(@"chat_liang");
        NSAttributedString *liangString = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(liangAttchment)];
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:self.uname attributes:@{NSFontAttributeName:RegularFont(12),NSForegroundColorAttributeName:Color(@"#86D9EF")}];
        [noteStr appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"：  %@",self.content] attributes:@{NSFontAttributeName:RegularFont(12),NSForegroundColorAttributeName:Color(@"#FFFFFF")}]];
        NSAttributedString *speaceString = [[NSAttributedString  alloc]initWithString:@" "];
    //    //插入靓号图标
        if (![self.liangname isEqual:@"0"] && ![self.liangname isEqual:@"(null)"] && self.liangname !=nil && self.liangname !=NULL) {
            [noteStr insertAttributedString:speaceString atIndex:0];//插入到第几个下标
            [noteStr insertAttributedString:liangString atIndex:0];//插入到第几个下标
        }
        //插入守护图标
        if ([self.guard_type intValue] == 1) {
            [noteStr insertAttributedString:speaceString atIndex:0];//插入到第几个下标
            [noteStr insertAttributedString:shouString atIndex:0];//插入到第几个下标
        }
        if ([self.guard_type intValue] == 2) {
            [noteStr insertAttributedString:speaceString atIndex:0];//插入到第几个下标
            [noteStr insertAttributedString:yearString atIndex:0];//插入到第几个下标
        }
        //插入管理图标
        if ([self.issuper integerValue] == 1) {
            [noteStr insertAttributedString:speaceString atIndex:0];//插入到第几个下标
            [noteStr insertAttributedString:adminString atIndex:0];//插入到第几个下标
        }
        //插入VIP图标
        if ([self.vip_type integerValue] == 1) {
            [noteStr insertAttributedString:speaceString atIndex:0];//插入到第几个下标
            [noteStr insertAttributedString:vipString atIndex:0];//插入到第几个下标
        }
        
        self.attContent = noteStr.copy;
    }
}
@end
