//
//  InfoCell.m
//  LOHAS乐活_App
//
//  Created by mac51 on 9/21/16.
//  Copyright © 2016 Aaron. All rights reserved.
//

#import "InfoCell.h"

@interface  InfoCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteNumLabel;

@property (weak, nonatomic) IBOutlet UIButton *buttonStatus;

@end
@implementation InfoCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)setIfModel:(InfoModel *)ifModel {
    _ifModel = ifModel;
    
    _iconImg.layer.masksToBounds=YES;
    _iconImg.layer.cornerRadius=_iconImg.width/2.0f;
    [_iconImg sd_setImageWithURL:_ifModel.avatar];
    _nameLabel.text = _ifModel.username;
    _noteNumLabel.text = [NSString stringWithFormat:@"%@条笔记",_ifModel.note_total];
    
    NSString *uidMine = [[IsLoginManager shareManage]getUidFromNSHomeDirectory];
    NSString *uid =_ifModel.uid;
    NSString *urlString = [NSString stringWithFormat:@"http://api.ilohas.com/v2/club/check_follow?uid=%@&follow_uid=%@",uidMine,uid];
    //获取管理对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //发起GET请求
    [manager GET:urlString
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSData *data = (NSData *)responseObject;
             NSDictionary *content = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
             NSDictionary *dic = content[@"content"];
             NSInteger guan = [dic[@"follow_status"] integerValue];
             if (guan == 1) {
                 _buttonStatus.selected = NO;
                 [_buttonStatus setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                 [_buttonStatus setTitle:@"已关注" forState:UIControlStateNormal];
                 [_buttonStatus setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
                 [_buttonStatus setTitle:@"关注" forState:UIControlStateSelected];
                 [_buttonStatus addTarget:self action:@selector(action1:) forControlEvents:UIControlEventTouchUpInside];
             }else if (guan == 0){
                 _buttonStatus.selected = NO;
                 [_buttonStatus setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                 [_buttonStatus setTitle:@"关注" forState:UIControlStateNormal];
                 [_buttonStatus setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
                 [_buttonStatus setTitle:@"已关注" forState:UIControlStateSelected];
                 [_buttonStatus addTarget:self action:@selector(action2:) forControlEvents:UIControlEventTouchUpInside];
             }
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"请求失败");
         }];
    
//    NSLog(@"%li",_ifModel.follow_status);
//    if (_ifModel.follow_status == 0) {
//        [_buttonStatus setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        [_buttonStatus setTitle:@"已关注" forState:UIControlStateNormal];
//    }else if (_ifModel.follow_status == 1){
//    [_buttonStatus setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    [_buttonStatus setTitle:@"关注" forState:UIControlStateNormal];
//    }
    
}
-(void)action1:(UIButton *)button{
    [button setBackgroundColor:[UIColor whiteColor]];
    button.selected = !button.selected;
}
-(void)action2:(UIButton *)button{
    [button setBackgroundColor:[UIColor whiteColor]];
  button.selected = !button.selected;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
