//
//  LoginViewController.m
//  LOHAS乐活_App
//
//  Created by mac51 on 9/14/16.
//  Copyright © 2016 Aaron. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
@interface LoginViewController ()<SinaWeiboDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.alpha = 0.95;
    [self buttonItemUpdate];
    
}
- (IBAction)threeButtonAction:(id)sender {
    SinaWeibo *weibo = kSinaWeiboObject;
    weibo.delegate =self;
    [weibo logIn];    
}
//登陆成功
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo {
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *useIDDic = @{@"useID" : sinaweibo.userID};
    NSDictionary *access_tokenDic = @{@"access_token" :sinaweibo.accessToken};
    //将认证数据 保存到属性列表中
    [userDef setObject:useIDDic forKey:kLohasUseIDSave];
    [userDef setObject:access_tokenDic forKey:kAccess_tokenSave];
    //数据同步
    [userDef synchronize];
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.ilohas.com/v2/login_by_openid?app_openid=%@&third_name=weibo",sinaweibo.userID];
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
             NSDictionary *uidDic = @{@"uid" : dic[@"uid"]};
             NSDictionary *tokenDic = @{@"token" : content[@"token"]};
             //将认证数据 保存到属性列表中
             NSUserDefaults *saveDefaults =  [NSUserDefaults standardUserDefaults];
             [saveDefaults setObject:uidDic forKey:kLohasUidSave];
             [saveDefaults setObject:tokenDic forKey:kLohasTokenSave];
             //数据同步
             [saveDefaults synchronize];
             [self.navigationController popViewControllerAnimated:YES];
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"请求失败");
         }];
    
}
-(void)buttonItemUpdate{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    //按钮的背景图片
    [button setBackgroundImage:[UIImage imageNamed:@"btn_close"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
}
-(void)action:(UIButton *)button{
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
