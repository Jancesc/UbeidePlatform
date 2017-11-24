//
//  DMPictureView.h
//  DMPictureBrowserViewControllerDemo
//
//  Created by Damai on 15/10/22.
//  Copyright © 2015年 Damai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMPictureModel.h"
@class DMPictureView;

@protocol DMPictureViewDelegate <NSObject>

- (void)DMPictureViewHandleSingleTap:(DMPictureView *)pictureView;

@end
@interface DMPictureView : UIScrollView
//图片
@property (nonatomic, strong) DMPictureModel *pictureModel;
//代理
@property (nonatomic, weak) id <DMPictureViewDelegate> pictureViewDelegate;

@end
