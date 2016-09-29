
//
//  MagazineModel.m
//  LOHAS乐活_App
//
//  Created by mac51 on 9/20/16.
//  Copyright © 2016 Aaron. All rights reserved.
//

#import "MagazineModel.h"

@implementation MagazineModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             //key Model类中属性的名字
             //value 字典中，属性对应的Key
             @"idStr" : @"id",
             @"typeidStr" :@"typeid"
             };
    
}
@end
