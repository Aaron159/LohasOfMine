//
//  BaseNavigationController.m
//  仿LOHAS生活App
//
//  Created by mac51 on 9/12/16.
//  Copyright © 2016 Aaron. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav.png"] forBarMetrics:UIBarMetricsDefault];
    
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:20],
                                NSForegroundColorAttributeName : [UIColor blackColor]};
    self.navigationBar.titleTextAttributes = attributes;
    
     //将导航栏设置为不透明  会影响每一个视图的布局
     self.navigationBar.translucent = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
////状态栏字体颜色
//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
