//
//  SquareModel.h
//  LOHAS乐活_App
//
//  Created by mac51 on 9/18/16.
//  Copyright © 2016 Aaron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContentModel.h"
@interface SquareModel : NSObject
@property(nonatomic,copy) NSString *idStr;
@property(nonatomic,copy) NSString *uid;
@property(nonatomic,copy) NSString *feed_type;
@property(nonatomic,copy) NSString *item_id;
@property(nonatomic,strong) ContentModel *content;
@property(nonatomic,assign) NSInteger likes;
@property(nonatomic,assign) NSInteger replies;
@property(nonatomic,assign) NSTimeInterval dateline;
@property(nonatomic,assign) NSInteger comment_id;
@property(nonatomic,assign) NSInteger page_id;
@property(nonatomic,assign) NSInteger reads;
@property(nonatomic,copy) NSString *username;
@property(nonatomic,copy) NSURL *avatar;
@property(nonatomic,copy) NSArray *zan;

@property(nonatomic,copy) NSDictionary *article;

@end
