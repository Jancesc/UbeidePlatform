//
//  DMPhoto.h
//  DMPhotoBrowser
//
//  Created by Damai on 15/9/25.
//  Copyright © 2015年 Damai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DMPhoto : NSObject

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) UIImage *fullScreenImage; // 完整的图片

@property (nonatomic, strong) UIView *srcView; // 来源view，用于frame的转换
@property (nonatomic, strong) UIImage *thumbnail;
//第一张显示
@property (nonatomic, assign) BOOL firstShow;

// 是否已经保存到相册
@property (nonatomic, assign) BOOL save;
// 索引
@property (nonatomic, assign) NSInteger index;
@end

