//
//  MainTabBarController.m
//  仿LOHAS生活App
//
//  Created by mac51 on 9/12/16.
//  Copyright © 2016 Aaron. All rights reserved.
//

#import "MainTabBarController.h"

@interface MainTabBarController (){

    UIImageView *_selectImage;
}
@end

@implementation MainTabBarController

-(instancetype)init {

    self = [super init];
    if (self) {
        [self createSubViewController];
        [self customTabBar];
    }

    return self;
}

//创建子控制器
- (void)createSubViewController {
    NSArray *storyboardNames = @[@"Recommend",
                                 @"Magazine",
                                 @"Shopping",
                                 @"Mine"];
    
    NSMutableArray *mArray = [[NSMutableArray alloc] init];
    
    //遍历所有的StoryBoard，获取视图控制器
    for (NSString *sbName in storyboardNames) {
        //读取故事版
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:sbName bundle:[NSBundle mainBundle]];
        //导航控制器
        UINavigationController *navi = [storyboard instantiateInitialViewController];
        
        //将读取到的视图控制器，添加到viewControllers数组中
        [mArray addObject:navi];
    }
    
    self.viewControllers = [mArray copy];
    
    
}
//自定义标签栏按钮
- (void)customTabBar {
    
    //设置标签栏背景
    self.tabBar.backgroundImage = [UIImage imageNamed:@"nav1"];

    //删除原有按钮
    //获取标签栏的子视图
    for (UIView *subView in self.tabBar.subviews) {
        //判断获取到的子视图，是否是标签栏上面的按钮
        Class buttonClass = NSClassFromString(@"UITabBarButton");
        if ([subView isKindOfClass:buttonClass]) {
            //视图是UITabBarButton
            [subView removeFromSuperview];
        }
    }
    //按钮宽度
    CGFloat buttonWidth = kScreenWidth / 4;
    
    //自定义添加按钮  home_tab_icon_5.png
    //循环创建五个按钮
    for (int i = 0; i < 4; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        //计算frame
        CGRect frame = CGRectMake(buttonWidth * i + (buttonWidth -49)/2, 0, 49, 49);
        button.frame = frame;
        //设置图片
        NSString *imageName = [NSString stringWithFormat:@"menb%i.png", i + 1];
        [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        NSString *imageName1 = [NSString stringWithFormat:@"menb%is.png",i + 1];
        [button setBackgroundImage:[UIImage imageNamed:imageName1] forState:UIControlStateSelected];
        [self.tabBar addSubview: button];
        button.tag = i;
        if (i == 0) {
            button.selected = YES;
        }
        //实现点击按钮，页面切换
        [button addTarget:self action:@selector(tabBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    /*
    //选中框
//    _selectImage = [[UIImageView alloc] initWithFrame:CGRectMake((buttonWidth -49)/2, 0, 49, 49)];
//    _selectImage.image = [UIImage imageNamed:@"menb1s.png"];
//    [self.tabBar insertSubview:_selectImage atIndex:1];
    */
//    //标签栏的阴影
    self.tabBar.shadowImage = [[UIImage alloc] init];
    
}


- (void)tabBarButtonAction:(UIButton *)button {
    self.selectedIndex = button.tag;
    for (UIView *subView in self.tabBar.subviews) {
        Class buttonClass = NSClassFromString(@"UIButton");
        if ([subView isKindOfClass:buttonClass]) {
            UIButton *btn = (UIButton *)subView;
            btn.selected = NO;
        }
    }
    //设置selected属性
    button.selected = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
