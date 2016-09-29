//
//  ContentModel.m
//  LOHAS乐活_App
//
//  Created by mac51 on 9/18/16.
//  Copyright © 2016 Aaron. All rights reserved.
//

#import "ContentModel.h"

@implementation ContentModel
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSString *path = dic[@"file_path"];
    NSString *img = dic[@"file_image_thumb"];
//    if (![path isKindOfClass:[NSString class]] && ![img isKindOfClass:[NSString class]]) {
//        return NO;
//    }
    NSArray *p = [path componentsSeparatedByString:@"|"];
    NSArray *i = [img componentsSeparatedByString:@"|"];
    
    if (i.count == 1) {
        NSString *s = [i firstObject];
        if ([s isEqualToString:@""]) {
            i = nil;
        }
    }
    if (p.count == 1) {
        NSString *s = [p firstObject];
        if ([s isEqualToString:@""]) {
            p = nil;
        }
    }
    _file_path = p;
    _file_image_thumb = i;
    return YES;
}
@end
