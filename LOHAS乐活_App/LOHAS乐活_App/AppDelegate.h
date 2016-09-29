//
//  AppDelegate.h
//  LOHAS乐活_App
//
//  Created by mac51 on 9/12/16.
//  Copyright © 2016 Aaron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//微博对象
@property (strong, nonatomic) SinaWeibo *sinaWeibo;
@property (strong,nonatomic) UIView *grayView;
@end

