//
//  MagazineModel.h
//  LOHAS乐活_App
//
//  Created by mac51 on 9/20/16.
//  Copyright © 2016 Aaron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MagazineModel : NSObject
@property (nonatomic,copy) NSString *idStr;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSURL *cover;
@property (nonatomic,copy) NSString *pub_date;
@property (nonatomic,copy) NSString *likes;
@property (nonatomic,copy) NSString *favorites;
@property (nonatomic,copy) NSString *replies;
@property (nonatomic,copy) NSString *year;
@property (nonatomic,copy) NSString *typeidStr;
@property (nonatomic,copy) NSString *intro;
@property (nonatomic,copy) NSString *recomment;
@property (nonatomic,assign) NSTimeInterval dateline;
@end
