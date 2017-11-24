//
//  DMAssetsPickerCollectionViewCell.h
//  DMMultiImagePicker
//
//  Created by Damai on 15/9/10.
//  Copyright (c) 2015年 Damai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DMAssetModel,DMAssetsPickerCollectionViewCell,ALAssetsGroup;

@protocol DMAssetsPickerCollectionViewCellDelegate <NSObject>

@optional

- ( void ) DidSelectedDMAssetsPickerCollectionViewCell : ( DMAssetsPickerCollectionViewCell * ) assetsPickerCollectionViewCell;

- ( void ) DidClickDMAssetsPickerCollectionViewCell : ( DMAssetsPickerCollectionViewCell * )assetsPickerCollectionViewCell;

@end
@interface DMAssetsPickerCollectionViewCell : UICollectionViewCell

@property ( nonatomic, strong ) DMAssetModel *assetModel;
@property ( nonatomic, weak ) id < DMAssetsPickerCollectionViewCellDelegate > delegate;

- (void) changSelectedButtonStatus;
@end
