//
//  HeaderView.m
//  LOHAS乐活_App
//
//  Created by mac51 on 9/21/16.
//  Copyright © 2016 Aaron. All rights reserved.
//

#import "HeaderView.h"

@interface HeaderView()
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *diaryLanel;
@property (weak, nonatomic) IBOutlet UILabel *oneLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoLabel;

@end
@implementation HeaderView

-(void)awakeFromNib {
    [super awakeFromNib];
     [self createUI];
}
-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }

    return self;
}
-(void)createUI {
    NSString *s = [[IsLoginManager shareManage]getUidFromNSHomeDirectory];
    NSString *urlString = [NSString stringWithFormat:@"http://api.ilohas.com/v2/club/get_user_info?uid=%@",s];
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
             [_img sd_setImageWithURL:[NSURL URLWithString:dic[@"avatar"]]];
             _nameLabel.text = dic[@"username"];
             _diaryLanel.text = dic[@"note_total"];
             _oneLabel.text = dic[@"follows"];
             _twoLabel.text = dic[@"fans"];
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"请求失败");
         }];
    
    _img.layer.masksToBounds=YES;
    _img.layer.cornerRadius=_img.width/2.0f; //设置为图片宽度的一半出来为圆形
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
