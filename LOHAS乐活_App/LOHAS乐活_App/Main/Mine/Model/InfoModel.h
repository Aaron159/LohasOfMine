//
//  InfoModel.h
//  LOHAS乐活_App
//
//  Created by mac51 on 9/21/16.
//  Copyright © 2016 Aaron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InfoModel : NSObject
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSURL *avatar;
@property (nonatomic,copy) NSString *note_total;
@property (nonatomic,assign)NSInteger follow_status;
@end
