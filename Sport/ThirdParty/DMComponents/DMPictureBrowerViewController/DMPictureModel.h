//
//  DMPictureModel.h
//  DMPictureBrowserViewControllerDemo
//
//  Created by Damai on 15/10/22.
//  Copyright © 2015年 Damai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DMPictureModel : NSObject
@property (nonatomic, strong) UIImage *image; // 完整的图片
@property (nonatomic, assign) NSInteger index;

-(instancetype)initWithImage: (UIImage *)image index: (NSInteger) index;
@end
