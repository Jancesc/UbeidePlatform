//
//  DMPictureBrowerViewController.h
//  DMPictureBrowserViewControllerDemo
//
//  Created by Damai on 15/10/22.
//  Copyright © 2015年 Damai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DMPictureBrowerViewController;

@protocol DMPictureBrowerViewControllerDelegate <NSObject>

- (void) DMPictureBrowerViewController: (DMPictureBrowerViewController *)DMPictureBrowerViewController DidDeletePictureWithIndex: (NSInteger)index;

- (void) DMPictureBrowerViewControllerDidDeleteAllPictures: (DMPictureBrowerViewController *)DMPictureBrowerViewController;

@end

@interface DMPictureBrowerViewController : UIViewController

@property (nonatomic, weak) id <DMPictureBrowerViewControllerDelegate> delegate;
@property (nonatomic, assign) BOOL showDeleteButton;

- (instancetype)initWithImageArray: (NSArray *)imageArray currentIndex: (NSUInteger)currentIndex;

@end
