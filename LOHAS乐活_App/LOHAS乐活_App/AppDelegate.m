//
//  AppDelegate.m
//  LOHAS乐活_App
//
//  Created by mac51 on 9/12/16.
//  Copyright © 2016 Aaron. All rights reserved.
//

#import "AppDelegate.h"
#import "MMDrawerController.h"
#import "MainTabBarController.h"
#import "LeftViewController.h"
#import "BaseNavigationController.h"

#define kWeiboAuthDataKey @"kWeiboAuthDataKey"
#define kWeiboAuthDataKey @"kWeiboAuthDataKey"
#define color ([[IsLoginManager shareManage]getBgColorFromNSHomeDirectory])
@interface AppDelegate ()<SinaWeiboDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"%@",NSHomeDirectory());
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    //创建标签控制器
    MainTabBarController *tab = [[MainTabBarController alloc] init];
    //左边
    LeftViewController *leftVC = [[LeftViewController alloc] init];
    //导航
    BaseNavigationController *leftNavi = [[BaseNavigationController alloc] initWithRootViewController:leftVC];
    
    //创建MMDraw
    MMDrawerController *mmd = [[MMDrawerController alloc] initWithCenterViewController:tab leftDrawerViewController:leftNavi];
    
    //设置侧滑宽度
    mmd.maximumLeftDrawerWidth = 300;
    //设置打开方式
    [mmd setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [mmd setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
    //设置根视图控制器
    self.window.rootViewController = mmd;
    
    //初始化微博SDK
    _sinaWeibo = [[SinaWeibo alloc] initWithAppKey:@"3619407204"
                                    appSecret:@"1a99b9f6ea6d8b240ea69f55b4829c02"
                                    appRedirectURI:@"http://www.baidu.com"
                                       andDelegate:self];
    self.grayView = [[UIView alloc] initWithFrame:self.window.bounds];
    self.grayView.backgroundColor =[UIColor blackColor];
    self.grayView.alpha = 0.5;
    self.grayView.userInteractionEnabled = NO;
    [self.window addSubview:_grayView];
    
    if ([color isEqualToString:@"black"]) {
        self.grayView.hidden = NO;
    }else{
        self.grayView.hidden = YES;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeView:) name:kNotifacationBgColor object:nil];
    return YES;
}
-(void)changeView:(NSNotification *)noti{
    if ([color isEqualToString:@"black"]) {
        self.grayView.hidden = NO;
    }else{
        self.grayView.hidden = YES;
    }
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
#pragma mark - 登陆/登出
////登陆成功
//- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo {
//    NSLog(@"登陆成功:%@", sinaweibo.accessToken);
//    
//    [self saveAuthData];
//    
//    
//}
////登陆失败
//- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error {
//    NSLog(@"登录失败");
//}

////登陆信息过期
//- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error {
//    //登出微博
//    [self.sinaWeibo logOut];
//    //删除本地登陆信息
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kWeiboAuthDataKey];
//    //重新登陆微博
//    [self.sinaWeibo logIn];
//}

//
////注销微博
//- (void)logoutWeibo {
//    //登出微博
//    [_sinaWeibo logOut];
//    
//}

////注销之后 所调用的方法
//- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo {
//    NSLog(@"注销成功");
//    //删除登陆信息
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kWeiboAuthDataKey];
//    
//}


#pragma mark - 保持登陆状态
//将登陆后的数据，保存到本地磁盘。token,uid
////保存认证信息
//- (void)saveAuthData {
//    
//    //用户令牌 token
//    NSString *token = _sinaWeibo.accessToken;
//    //用户ID uid
//    NSString *uid = _sinaWeibo.userID;
//    //认证的有效期限 长期不使用，会导致token失效
//    NSDate *date = _sinaWeibo.expirationDate;
//    
//    //使用属性列表，保存登陆数据到本地
//    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
//    
//    NSDictionary *dic = @{@"accessToken" : token,
//                          @"uid" : uid,
//                          @"expirationDate" : date};
//    //将认证数据 保存到属性列表中
//    [userDef setObject:dic forKey:kWeiboAuthDataKey];
//    //数据同步
//    [userDef synchronize];
//    
//}

//读取登陆信息
//- (BOOL)readAuthData {
//    
//    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
//    //读取数据
//    NSDictionary *dic = [userDef objectForKey:kWeiboAuthDataKey];
//    //判断是否读取成功
//    if (dic == nil) {
//        //读取数据失败，没有登陆
//        return NO;
//    }
//    
//    //获取保存的数据
//    NSString *token = dic[@"accessToken"];
//    NSString *uid = dic[@"uid"];
//    NSDate *date = dic[@"expirationDate"];
//    if (token == nil || uid == nil || date == nil) {
//        //保存的数据有误 重新登陆
//        return NO;
//    }
//    
//    //读取成功，使用保存过的数据
//    _sinaWeibo.accessToken = token;
//    _sinaWeibo.userID = uid;
//    _sinaWeibo.expirationDate = date;
//    
//    return YES;
//}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
