//
//  DMAssetGroupViewController.h
//  DMMultiImagePicker
//
//  Created by Damai on 15/9/10.
//  Copyright (c) 2015年 Damai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class DMAssetGroupViewController,DMAssetModel,ALAssetsGroup;

@protocol DMAssetGroupViewControllerDelegate < NSObject >

@optional

- (void) DMAssetGroupViewController : (DMAssetGroupViewController *) assetGroupViewController didFinishPickingImagesWithAssets : (NSArray *) assetss;


@end

@interface DMAssetGroupViewController : UITableViewController

- (instancetype) initWithMaxCount : (int) MaxCount;
- (instancetype) initWithMaxCount:(int)MaxCount directToPickerView : (BOOL)direct;
- (instancetype) initWithDirectToPickerView : (BOOL)direct;
@property ( nonatomic, weak ) id < DMAssetGroupViewControllerDelegate > delegate;

@property (nonatomic, copy) void (^completion)(NSArray *);

@end
