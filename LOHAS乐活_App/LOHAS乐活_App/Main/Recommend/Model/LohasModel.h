//
//  LohasModel.h
//  LOHAS乐活_App
//
//  Created by mac51 on 9/13/16.
//  Copyright © 2016 Aaron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LinkModel.h"
@interface LohasModel : NSObject

@property (nonatomic,assign) NSInteger idStr;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSURL *cover_small;
@property (nonatomic,copy) NSURL *image;
@property (nonatomic,copy) NSURL *app_cover;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *seo_keywords;
@property (nonatomic,copy) NSString *likes;
@property (nonatomic,copy) NSString *favorites;
@property (nonatomic,copy) NSString *hits;
@property (nonatomic,copy) NSString *replies;
@property (nonatomic,assign) NSTimeInterval dateline;
@property (nonatomic,copy) NSURL *url;
@property (nonatomic,copy) NSString *ord;
@property (nonatomic,copy) NSArray *link;
@end
