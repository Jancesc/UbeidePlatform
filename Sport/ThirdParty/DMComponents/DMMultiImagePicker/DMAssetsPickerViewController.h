//
//  DMAssetsPickerViewController.h
//  DMMultiImagePicker
//
//  Created by Damai on 15/9/10.
//  Copyright (c) 2015年 Damai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ALAssetsGroup,DMAssetsPickerViewController;

@protocol DMAssetsPickerViewControllerDelegate <NSObject>

@optional

- (void) DMAssetsPickerViewController : ( DMAssetsPickerViewController * ) assetsPickerViewController finishedPickingWithAssets : ( NSArray * )assets;

@end

@interface DMAssetsPickerViewController : UICollectionViewController


@property ( nonatomic, weak ) id <DMAssetsPickerViewControllerDelegate> delegate ;

- (instancetype)initWithMaxCount: (int) maxcount group: (ALAssetsGroup *)group;

@end
