//
//  LinkModel.h
//  LOHAS乐活_App
//
//  Created by mac51 on 9/13/16.
//  Copyright © 2016 Aaron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LinkModel : NSObject
@property (nonatomic,assign) NSInteger linkID;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,assign) NSInteger article_id;
@property (nonatomic,copy) NSURL *url;
@end
