//
//  IsLoginManager.h
//  LOHAS乐活_App
//
//  Created by mac51 on 9/19/16.
//  Copyright © 2016 Aaron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface IsLoginManager : NSObject
//获取单例类
+ (IsLoginManager *)shareManage;

-(NSString *)getUidFromNSHomeDirectory;
-(NSString *)getUseIDFromNSHomeDirectory;
-(NSString *)getTokenFromNSHomeDirectory;
-(NSString *)getAccess_TokenFromNSHomeDirectory;
-(NSString *)getBgColorFromNSHomeDirectory;

-(BOOL)judgeNeedsPush:(UIViewController *)vc;
-(void)clearLoginInfo;
@end
