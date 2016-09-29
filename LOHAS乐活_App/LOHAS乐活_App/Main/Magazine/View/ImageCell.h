//
//  ImageCell.h
//  LOHAS乐活_App
//
//  Created by mac51 on 9/22/16.
//  Copyright © 2016 Aaron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageModel.h"
@interface ImageCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIWebView *everyImage;


@property (nonatomic,strong) ImageModel *igModel;

@end
