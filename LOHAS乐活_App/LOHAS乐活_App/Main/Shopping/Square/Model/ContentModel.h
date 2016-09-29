//
//  ContentModel.h
//  LOHAS乐活_App
//
//  Created by mac51 on 9/18/16.
//  Copyright © 2016 Aaron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContentModel : NSObject
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *file_type;
@property (nonatomic,copy) NSString *file_time;
@property (nonatomic,copy) NSString *file_title;
@property (nonatomic,copy) NSString *file_cover;
@property (nonatomic,copy) NSArray *file_path;
@property (nonatomic,copy) NSArray *file_image_thumb;

@end
