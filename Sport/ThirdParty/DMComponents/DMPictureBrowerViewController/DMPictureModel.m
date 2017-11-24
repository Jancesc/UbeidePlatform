//
//  DMPictureModel.m
//  DMPictureBrowserViewControllerDemo
//
//  Created by Damai on 15/10/22.
//  Copyright © 2015年 Damai. All rights reserved.
//

#import "DMPictureModel.h"

@implementation DMPictureModel

-(instancetype)initWithImage:(UIImage *)image index:(NSInteger)index
{
    if (self = [super init]) {
        
        self.index = index;
        self.image = image;
    }
    return self;
}
@end
