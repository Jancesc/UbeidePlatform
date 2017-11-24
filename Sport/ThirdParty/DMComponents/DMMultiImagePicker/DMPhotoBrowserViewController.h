//
//  DMPhotoBrowserViewController.h
//  DMMultiImagePickerDemo
//
//  Created by Damai on 15/9/30.
//  Copyright © 2015年 Damai. All rights reserved.
//

#import <UIKit/UIKit.h>

#define padding 10

@class DMPhotoBrowserViewController , DMAssetModel;

@protocol DMPhotoBrowserViewControllerDelegate <NSObject >

- (void) DMPhotoBrowserViewController : ( DMPhotoBrowserViewController *) photoBrowserViewController finishBrowserWithAssetModels :( NSArray *) assetModels;
- (void) DMPhotoBrowserViewController : ( DMPhotoBrowserViewController *) photoBrowserViewController backButtonOnClickWithAssetModels:(NSArray *)assetModels;

@end

@interface DMPhotoBrowserViewController : UIViewController

@property ( nonatomic, strong ) id <DMPhotoBrowserViewControllerDelegate> delegate;
@property ( nonatomic, strong ) UIScrollView *browserView;

- ( instancetype ) initWithAssetsModels : ( NSArray *) assetsModelArray;
- ( instancetype ) initWithAssetsModels : ( NSArray *) assetsModelArray maxSelectedCount : (int)maxCount selectedCount: (NSUInteger) selectedCount;

- (void) setBrowserViewContentOffet: (CGPoint)offet;
@end
