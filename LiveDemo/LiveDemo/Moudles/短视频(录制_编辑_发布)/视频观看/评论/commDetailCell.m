//
//  commDetailCell.m
//  yunbaolive
//
//  Created by Boom on 2018/12/17.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "commDetailCell.h"
//#import "otherUserMsgVC.h"

@implementation commDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _headImg = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0, 20, 20)];
        _headImg.layer.cornerRadius = 10;
        _headImg.layer.masksToBounds = YES;
        _headImg.userInteractionEnabled = YES;
        [self.contentView addSubview:_headImg];
        
        UITapGestureRecognizer *userTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userTapClick)];
        [_headImg addGestureRecognizer:userTap];
        
        _nameL = [[UILabel alloc]initWithFrame:CGRectMake(_headImg.right+5, 2, self.contentView.width, 20)];
        _nameL.textColor = RGB(130, 130, 130);
        _nameL.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_nameL];
        _contentL = [[UILabel alloc]init];
        _contentL.textColor = ColorAlpha(@"#333333", 1);
        _contentL.font = [UIFont systemFontOfSize:14];
        _contentL.numberOfLines = 0;
        [self.contentView addSubview:_contentL];

    }
    return self;
}
-(void)userTapClick{
//    otherUserMsgVC  *person = [[otherUserMsgVC alloc]init];
//    person.userID = _model.ID;
//    [[MXBADelegate sharedAppDelegate]pushViewController:person animated:YES];

}
- (void)setModel:(detailmodel *)model{
    _model = model;
    _nameL.text = _model.user_nicename;
    [_headImg sd_setImageWithURL:[NSURL URLWithString:model.avatar_thumb]];
    _contentL.frame = _model.contentRect;
    NSArray *resultArr  = [NSString machesWithPattern:@"\\[\\w+\\]" andStr:_model.content];
    if (!resultArr) return;
    NSUInteger lengthDetail = 0;
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:_model.content];
    //遍历所有的result 取出range
    for (NSTextCheckingResult *result in resultArr) {
        //取出图片名
        NSString *imageName =   [_model.content substringWithRange:NSMakeRange(result.range.location, result.range.length)];
        NSLog(@"--------%@",imageName);
        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        UIImage *emojiImage = [UIImage imageNamed:imageName];
        NSAttributedString *imageString;
        if (emojiImage) {
            attach.image = emojiImage;
            attach.bounds = CGRectMake(0, -2, 15, 15);
            imageString =   [NSAttributedString attributedStringWithAttachment:attach];
        }else{
            imageString =   [[NSMutableAttributedString alloc]initWithString:imageName];
        }
        //图片附件的文本长度是1
        NSLog(@"emoj===%zd===size-w:%f==size-h:%f",imageString.length,imageString.size.width,imageString.size.height);
        NSUInteger length = attStr.length;
        NSRange newRange = NSMakeRange(result.range.location - lengthDetail, result.range.length);
        [attStr replaceCharactersInRange:newRange withAttributedString:imageString];
        
        lengthDetail += length - attStr.length;
    }
    NSAttributedString *dateStr = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@" %@",_model.datetime] attributes:@{NSForegroundColorAttributeName:ColorAlpha(@"#959697", 1),NSFontAttributeName:[UIFont systemFontOfSize:11]}];
    [attStr appendAttributedString:dateStr];
    //更新到label上
    _contentL.attributedText = attStr;

}

@end
