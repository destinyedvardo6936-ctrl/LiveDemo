//
//  LCLiveDetailViewModel+LCSocketViewModel.m
//  LiveDemo
//
//  Created by mrgao on 2023/3/6.
//

#import "LCLiveDetailViewModel+LCSocketViewModel.h"

@implementation LCLiveDetailViewModel (LCSocketViewModel)
- (void)connectToSocket{
    [[LCSocketManager shareManager] connetToSever:self.dataModel.chatserver delegate:self roomId:self.dataModel.uid stream:self.dataModel.stream];
}
- (void)disconnetSocket{
    [[LCSocketManager shareManager] disconnect];
}

- (void)connectFailured:(NSError *)error{
    
}
- (void)connectSuccess:(id)result{
    if([LCGameConfigManager shareManager].gameStatus && self.origalModel.caipiao.biaoshi.length){
        [self sendStartPlayLotteryTicketWithBiaoshi:self.origalModel.caipiao.biaoshi];
    }
}
- (void)disConnect:(id)result{
    
}
- (void)netWorkChanged{
    
}
//- (void)sendMessageSuccess:(id)result;
//- (void)sendMessageFailured:(NSError *)error;
- (void)receiveMessage:(id)message{
    for (NSString *jsonStr in message) {
        if ([[message[0] firstObject] isEqualToString:@"stopplay"]) {
            [self.roomCloseByAdminSubject sendNext:@(YES)];
            [self disconnetSocket];
        }else{
            id msg = [jsonStr mj_JSONObject];
            if([msg isKindOfClass:NSArray.class]){
                NSDictionary *dic  = [[msg firstObject] mj_JSONObject];
                
                NSString *retcode = [NSString stringWithFormat:@"%@",dic[@"retcode"] ];
                NSString *retmsg = dic[@"retmsg"] ;
                NSDictionary *msgDic = [dic[@"msg"] firstObject];
                NSString *method = msgDic[@"_method_"];
                NSString *msgtype = msgDic[@"msgtype"];
                NSString *action = msgDic[@"action"];
                id ct = msgDic[@"ct"];
                if([retcode isEqualToString:@"409002"]){
                    [self.shutUpSubject sendNext:KLanguage(@"你已被禁言")];
                }else{
                    //观众即僵尸粉
                    if ([method isEqual:@"requestFans"]){
                        NSArray *ctArr = ct;
                        NSDictionary *data = [ctArr firstObject];
                        if([data[@"code"] intValue] == 0){
                            NSDictionary *infoDic = data[@"info"];
                            NSArray *list = infoDic[@"list"];
                            [LCLiveUserModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                                return @{@"userId":@"id",@"issuper":@"isadmin"};
                            }];
                            NSArray *arr = [LCLiveUserModel mj_objectArrayWithKeyValuesArray:list];
                            NSMutableArray *temp = [NSMutableArray arrayWithArray:self.dataModel.userlists];
                            
                            [temp replaceObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:arr.count > 4 ? NSMakeRange(0, 4):NSMakeRange(4-arr.count, arr.count)] withObjects:arr.count > 4 ? [arr subarrayWithRange:NSMakeRange(0, 4)]:arr];
                            self.dataModel.userlists = temp.copy;
                            [self.audienceChangeSubject sendNext:@(YES)];
                        }
                    }else if ([method isEqualToString:@"roomUserNum"]){
                        NSDictionary *ctDic = [ct mj_JSONObject];
                        
                        self.dataModel.nums = [NSString stringWithFormat:@"%ld", [ctDic[@"roomusernum"]integerValue]];
                    }else if ([method isEqualToString:@"SystemNot"]){
                        if([msgtype integerValue] == 4 && [action integerValue] == 1){
                            NSString *content = ct;
                            //进入直播间公告消息 如直播内容包含任何低俗、暴露和涉黄内容，账号会被封禁；安全部门会24小时巡查哦～
                            LCChatMessageModel *model = [LCChatMessageModel new];
                            model.type = 1;
                            model.content = [NSString stringWithFormat:@"%@%@",KLanguage(@"直播间消息"),content];
                            [model changeContentToAtttributeString];
                            [self.msgArray insertObject:model atIndex:0];
                            [self.messageAddSubject sendNext:@(YES)];
                        }else if ([msgtype integerValue] == 5 && [action integerValue] == 14){
                            //跟投
                            [LCChatMessageModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                                return @{@"content":@"msgStr"};
                            }];
                            NSDictionary *ctDic = [msgDic[@"ct"] mj_JSONObject];
                            
                            LCChatMessageModel *model =  [LCChatMessageModel mj_objectWithKeyValues:msgDic];
                           
                            model.type = 4;
                            model.content = msgDic[@"msgStr"];
                            model.lotteryTicketDic = ctDic;
                            [self.msgArray addObject:model];
                            [self.messageAddSubject sendNext:@(YES)];
                        }
                        
                    }else if ([method isEqualToString:@"SendMsg"]){
                        if(msgtype.intValue == 0){
                            if(action.intValue == 0){
                                //用户进入
                                [LCLiveUserModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                                    return @{@"userId":@"id",@"issuper":@"isadmin"};
                                }];
                                LCLiveUserModel *model = [LCLiveUserModel mj_objectWithKeyValues:ct];
                                [self.userAccessArray removeAllObjects];
                                [self.userAccessArray addObject:model];
                                NSMutableArray *temp = [NSMutableArray arrayWithArray:self.dataModel.userlists];
                                if(temp.count < 4){
                                    [temp addObject:model];
                                }else{
                                    [temp replaceObjectAtIndex:3 withObject:model];
                                }
                                self.dataModel.userlists = temp.copy;
                                [self.userAccessSubject sendNext:model];
                                [self.audienceChangeSubject sendNext:@(YES)];
                            }else if (action.intValue == 1){
                                //用户离开
                                [LCLiveUserModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                                    return @{@"userId":@"id",@"issuper":@"isadmin"};
                                }];
                                LCLiveUserModel *model = [LCLiveUserModel mj_objectWithKeyValues:ct];
                                NSMutableArray *temp = [NSMutableArray arrayWithArray:self.dataModel.userlists];
                                NSInteger index = temp.count;
                                for (LCLiveUserModel *le in temp) {
                                    if([model.userId isEqualToString:le.userId]){
                                        index = [temp indexOfObject:le];
                                    }
                                }
                                if(index < temp.count){
                                    [temp removeObjectAtIndex:index];
                                }
                                self.dataModel.userlists = temp.copy;
                                [self.audienceChangeSubject sendNext:@(YES)];
                            }
                        }else if ([msgtype integerValue] == 2){
                            if([msgDic.allKeys containsObject:@"heart"]){
                                //点亮
                            }else{
                                //聊天
                                [LCChatMessageModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                                    return @{@"content":@"ct"};
                                }];
                                
                                LCChatMessageModel *messageModel = [LCChatMessageModel mj_objectWithKeyValues:msgDic];
                                messageModel.type = 2;
                                [messageModel changeContentToAtttributeString];
                                [self.msgArray addObject:messageModel];
                                [self.messageAddSubject sendNext:@(YES)];
                            }
                        }else if ([msgtype integerValue] == 1){
                            //关闭直播
                            if([action isEqualToString:@"18"]){
                                [self.liveEndSubject sendNext:@(YES)];
                            }
                        }
                    }else if ([method isEqualToString:@"SendGift"]){
                        {


                            LCChatGiftMessageModel *model = [LCChatGiftMessageModel mj_objectWithKeyValues:msgDic];
                            NSString *content = [NSString stringWithFormat:@"%@ %@%@",KLanguage(@"送出了"),model.ct.giftcount,model.ct.giftname];
                            LCChatMessageModel *messageModel = [LCChatMessageModel new];
                            [messageModel mj_setKeyValues:msgDic];
                            messageModel.content = content;
                            messageModel.uid = model.ct.uid;
                            messageModel.type = 3;
                            [messageModel changeContentToAtttributeString];
                            [self.msgArray addObject:messageModel];
                            [self.messageAddSubject sendNext:@(YES)];
                            [self.sendGiftSubject sendNext:model];


                            
                        }
                    } else if ([method isEqualToString:@"Sendplatgift"]){
                        //全站礼物
                        [self.giftAllPlatformSubject sendNext:msgDic];
                    }else if ([method isEqualToString:@"BuyGuard"]){
                    
                        self.dataModel.guard_nums = [NSString stringWithFormat:@"%ld",[msgDic[@"guard_nums"] integerValue]];
                        [LCChatMessageModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                            return @{@"content":@"ct"};
                        }];
                        LCChatMessageModel *messageModel = [LCChatMessageModel new];
                        [messageModel mj_setKeyValues:msgDic];
                        messageModel.type = 5;
                        [messageModel changeContentToAtttributeString];
                        [self.msgArray addObject:messageModel];
                        [self.messageAddSubject sendNext:@(YES)];
                    }else if([method isEqualToString:@"StartEndLive"]){
                        //结束直播
                        [self.liveEndSubject sendNext:@(YES)];
                    }else if([method isEqualToString:@"SendBarrage"])
                    {
                        NSDictionary *ctDic = [msgDic[@"ct"] mj_JSONObject];
                        NSString *text = [NSString stringWithFormat:@"%@",ctDic[@"content"]];
                        NSString *name =msgDic[@"uname"];
                        NSString *icon = msgDic[@"uhead"];
                        NSString *level = [NSString stringWithFormat:@"%ld",[msgDic[@"level"] integerValue]];
                        NSArray *arr = [LCConfigManager shareManager].configModel.level;
                        LCUserLevelModel *levelModel = nil;
                        for (LCUserLevelModel *le in arr) {
                            if([le.levelid isEqualToString: level]){
                                levelModel = le;
                            }
                        }
                        
                        NSDictionary *levelDic = [levelModel mj_keyValues];
                      
                        NSString *colorStr = minstr([levelDic valueForKey:@"colour"]);
                        
                        NSDictionary *userinfo = [[NSDictionary alloc] initWithObjectsAndKeys:text,@"title",name,@"name",icon,@"icon",colorStr,@"nameColor", nil];
                        [self.danmuSubject sendNext:userinfo];
                        
                    }else if ([method isEqualToString:@"changeLive"]){
                        //房间类型切换
        //                [self.socketDelegate changeLive:[NSString stringWithFormat:@"%@",[msg valueForKey:@"type_val"]]];
                    }else if ([method isEqualToString:@"updateVotes"]){
                        //增加映票
        //                NSString *msgtype = [msg valueForKey:@"msgtype"];
        //                if ([msgtype isEqual:@"26"])
        //                {
        //                    //限制进房间的时候自己不增加
        //                    NSString *uid = minstr([msg valueForKey:@"uid"]);
        //                    if (![uid isEqual:[LCUserInfoManager shareManager].userInfo.ID]) {
        //                        [self.socketDelegate addvotesdelegate:[msg valueForKey:@"votes"]];
        //                    }
        //                }
                    }
                    
                    
                }
                }
               
            
           
        }
    }

    
    
}


- (void)sendDanMuWithText:(NSString *)text{
    LCUserInfoModel *model = [LCUserInfoManager shareManager].userInfo;
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"SendBarrage",
                                        @"action": @"7",
                                        @"ct":text ,
                                        @"msgtype": @"1",
                                        
                                        @"uid": model.ID,
                                        @"uname": model.user_nicename,
                                        @"equipment": @"app",
                                        @"roomnum": self.origalModel.uid,
                                        @"level":model.level,
                                        @"uhead":model.avatar,
                                        @"vip_type":self.dataModel.vip_type,
                                        @"liangname":self.dataModel.liang_name
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [[LCSocketManager shareManager] sendMessage:msgData eventName:@"broadcast"];
//    [_ChatSocket emit:@"broadcast" with:msgData];
}
- (void)sendMessageWithText:(NSString *)text{
    LCUserInfoModel *model = [LCUserInfoManager shareManager].userInfo;
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_":@"SendMsg",
                                        @"action":@"0",
                                        @"ct":text,
                                        @"msgtype":@"2",
                                        @"timestamp":@"",
                                        @"tougood":@"",
                                        @"touid":@"0",
                                        @"city":@"",
                                        @"touname":@"",
                                        @"ugood":@"",
                                        @"uid":model.ID,
                                        @"uname":model.user_nicename,
                                        @"equipment":@"app",
                                        @"roomnum":self.archorModel.uid,
                                        @"usign":@"",
                                        @"uhead":@"",
                                        @"level":model.level,
                                        @"sex":@"",
                                        @"vip_type":self.dataModel.vip_type,
                                        @"liangname":self.dataModel.liang_name,
                                        @"isAnchor":@"0",
                                        @"usertype":self.dataModel.usertype,
                                        @"guard_type":self.dataModel.guard_type
                                        }
                                    ],
                            @"retcode":@"000000",
                            @"retmsg":@"OK"
                            }
                        ];
    [[LCSocketManager shareManager] sendMessage:msgData eventName:@"broadcast"];
}
- (void)sendGiftWithModel:(NSString *)giftToken num:(NSInteger)num{
    LCUserInfoModel *model = [LCUserInfoManager shareManager].userInfo;
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"SendGift",
                                        @"action": @"0",
                                        @"ct":giftToken ,
                                        @"msgtype": @"1",
                                        @"uid": model.ID,
                                        @"uname": model.user_nicename,
                                        @"equipment": @"app",
                                        @"roomnum": self.dataModel.uid,
                                        @"level":model.level,
                                        @"evensend":@"1",
                                        @"uhead":model.avatar,
                                        @"vip_type":self.dataModel.vip_type,
                                        @"liangname":self.dataModel.liang_name,
                                        @"livename":self.archorModel.user_nicename,
                                        @"paintedPath":@[],
                                        @"paintedHeight":@"0",
                                        @"paintedWidth":@"0"
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [[LCSocketManager shareManager] sendMessage:msgData eventName:@"broadcast"];
}
- (void)sendLotteryTicketMessage:(NSDictionary *)dic{
    LCUserInfoModel *model = [LCUserInfoManager shareManager].userInfo;
    NSString *msg = [NSString stringWithFormat:@"%@%@%@%@%@%@",model.user_nicename,KLanguage(@"在"),dic[@"title"],KLanguage(@"中下注了"),dic[@"allmoney"],KLanguage(@"元")];
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"SystemNot",
                                        @"action": @"14",
                                        @"msgtype":@"5",
                                        @"msgStr":msg,
                                        @"ct":dic ,
                                        @"money":dic[@"allmoney"],
                                        @"level":model.level,
                                        @"uid":model.ID,
                                        @"uname":model.user_nicename
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [[LCSocketManager shareManager] sendMessage:msgData eventName:@"broadcast"];
}
- (void)sendBuyGuardMessage:(NSDictionary *)dic{
    LCUserInfoModel *model = [LCUserInfoManager shareManager].userInfo;
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"BuyGuard",
                                        @"action":@"0",
                                        @"msgtype": @"0",
                                        @"ct":KLanguage(@"守护了主播"),
                                        @"uid":model.ID,
                                        @"uname":model.user_nicename,
                                        @"uhead":model.avatar_thumb,
                                        @"votestotal":minstr([dic valueForKey:@"votestotal"]),
                                        @"guard_nums":minstr([dic valueForKey:@"guard_nums"]),
                                        @"level":model.level,
                                        @"vip_type":self.dataModel.vip_type,
                                        @"liangname":self.dataModel.liang_name
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [[LCSocketManager shareManager] sendMessage:msgData eventName:@"broadcast"];

}
- (void)sendStartPlayLotteryTicketWithBiaoshi:(NSString *)biaoshi{
    LCUserInfoModel *model = [LCUserInfoManager shareManager].userInfo;
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_":@"gameinfo",
                                        @"caipiao":biaoshi,
                                        @"token": model.token
                                        }
                                    ],
                            @"retcode":@"000000",
                            @"retmsg":@"OK"
                            }
                        ];
    [[LCSocketManager shareManager] sendMessage:msgData eventName:@"game"];
}
- (void)sendEndPlayLotteryTicketWithBiaoshi:(NSString *)biaoshi{
    LCUserInfoModel *model = [LCUserInfoManager shareManager].userInfo;
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_":@"endgame",
                                        @"caipiao":biaoshi,
                                        @"token": model.token
                                        }
                                    ],
                            @"retcode":@"000000",
                            @"retmsg":@"OK"
                            }
                        ];
    [[LCSocketManager shareManager] sendMessage:msgData eventName:@"game"];
}
- (void)sendCheckResultLotteryTicketWithBiaoshi:(NSString *)biaoshi{
    LCUserInfoModel *model = [LCUserInfoManager shareManager].userInfo;
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_":@"checkgame",
                                        @"caipiao":biaoshi,
                                        @"token": model.token
                                        }
                                    ],
                            @"retcode":@"000000",
                            @"retmsg":@"OK"
                            }
                        ];
    [[LCSocketManager shareManager] sendMessage:msgData eventName:@"game"];
    
}
@end
