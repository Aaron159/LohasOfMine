//
//  InfoViewController.m
//  LOHAS乐活_App
//
//  Created by mac51 on 9/20/16.
//  Copyright © 2016 Aaron. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController (){
    
    UIImageView *_iconImg;
    UILabel *_nameLabel;

}

@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self loadNetData];
}
-(void)loadNetData {
    NSString *s =[[IsLoginManager shareManage]getUidFromNSHomeDirectory];
    if (s) {
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
                 _nameLabel.text = dic[@"username"];
                 [_iconImg sd_setImageWithURL:[NSURL URLWithString:dic[@"avatar"]]];
             }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 NSLog(@"请求失败");
             }];
    }
    
    
}
-(void)createUI {
   
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(40, 50, kScreenWidth - 80, 20)];
    l.textColor = [UIColor grayColor];
    l.text = @"您的LOHAS乐活俱乐部会员信息如下:";
    l.font = [UIFont boldSystemFontOfSize:14];
    l.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:l];
    
    _iconImg = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth -80)/2, 100, 80, 80)];
    _iconImg.backgroundColor = [UIColor cyanColor];
    _iconImg.layer.masksToBounds=YES;
    _iconImg.layer.cornerRadius=80/2.0f; //设置为图片宽度的一半出来为圆形
    [self.view addSubview:_iconImg];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 190, kScreenWidth-80, 25)];
    _nameLabel.text = @"年数据的规划";
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.font = [UIFont boldSystemFontOfSize:16];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_nameLabel];
    
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    b.frame = CGRectMake((kScreenWidth -120)/2, 300, 120, 30);
    [b setBackgroundColor:[UIColor redColor]];
    [b setTitle:@"退出登录" forState:UIControlStateNormal];
    [b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    b.layer.cornerRadius = 10.0;
    [b addTarget:self action:@selector(logOutAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    //按钮的背景图片
    [button setBackgroundImage:[UIImage imageNamed:@"btn_close"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;

}
-(void)action:(UIButton *)buttton {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)logOutAction{
    [[IsLoginManager shareManage] clearLoginInfo];
    [self.navigationController popViewControllerAnimated:YES];
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
