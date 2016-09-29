//
//  SquareModel.m
//  LOHAS乐活_App
//
//  Created by mac51 on 9/18/16.
//  Copyright © 2016 Aaron. All rights reserved.
//

#import "SquareModel.h"

@implementation SquareModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             //key Model类中属性的名字
             //value 字典中，属性对应的Key
             @"idStr" : @"id"
             };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    ContentModel *model = [ContentModel yy_modelWithJSON:dic[@"content"]];
    _content = model;
    return YES;
}
@end
