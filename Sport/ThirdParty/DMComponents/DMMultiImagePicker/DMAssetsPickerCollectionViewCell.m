//
//  DMAssetsPickerCollectionViewCell.m
//  DMMultiImagePicker
//
//  Created by Damai on 15/9/10.
//  Copyright (c) 2015年 Damai. All rights reserved.
//

#import "DMAssetsPickerCollectionViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "DMAssetModel.h"

#define selectedButtonWH 28

@interface DMAssetsPickerCollectionViewCell()

@property ( nonatomic, strong ) UIButton *imageButton;
@property ( nonatomic, strong ) UIButton *selectedButton;

@end

@implementation DMAssetsPickerCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [ super initWithFrame: frame ];
    if ( self ) {
        
        self.imageButton = [[ UIButton alloc ] init ];
        self.imageButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.selectedButton = [[ UIButton alloc ] init ];
        [ self.imageButton setAdjustsImageWhenHighlighted:NO ];
        [ self.selectedButton addTarget: self action: @selector( selectedButtonOnClick: ) forControlEvents:UIControlEventTouchUpInside ];
        
        [ self.imageButton setBackgroundColor: [UIColor whiteColor]];

        
        [ self.imageButton addTarget: self action: @selector( imageButtonOnClick: ) forControlEvents:UIControlEventTouchUpInside ];
    }
    return self;
}



- (void)selectedButtonOnClick : (UIButton *)button
{
    if ( [ self.delegate respondsToSelector: @selector( DidSelectedDMAssetsPickerCollectionViewCell: )] ) {
        
        [ self. delegate DidSelectedDMAssetsPickerCollectionViewCell: self ];
    }
}

-(void)changSelectedButtonStatus
{
    self.selectedButton.selected = !self.selectedButton.selected;
}


- (void) imageButtonOnClick : (UIButton *) button
{
    if ( [self.delegate respondsToSelector: @selector( DidClickDMAssetsPickerCollectionViewCell: )])
    {
        
        [self.delegate DidClickDMAssetsPickerCollectionViewCell: self ];
    }
}

- (void)setAssetModel:(DMAssetModel *)assetModel
{
    
    _assetModel = assetModel ;
    
    //设置Cell的tag
    self.tag = assetModel.tag;
    
    //设置图像
    UIImage *image = [ UIImage imageWithCGImage: [ assetModel.asset aspectRatioThumbnail ]];
    [ self.imageButton setImage: image  forState: UIControlStateNormal ] ;
    [ self.imageButton setImage: image  forState: UIControlStateHighlighted ];
    
    //设置选中图标
    
    [ self.selectedButton setImage: [UIImage imageNamed: @"DMMultiImagePicker.bundle/unclick"] forState: UIControlStateNormal] ;
    [ self.selectedButton setImage: [UIImage imageNamed: @"DMMultiImagePicker.bundle/clicked"] forState:UIControlStateSelected] ;
    self.selectedButton.selected = assetModel.selected ;
    
    [ self.imageButton addSubview: self.selectedButton ];
    [ self.contentView addSubview: self.imageButton ];
}



- (void)layoutSubviews
{
    
    [super layoutSubviews];
    
    //设置imageButton的Frame
    self.imageButton.frame = self.contentView.frame;
    self.imageButton.imageView.frame = self.imageButton.bounds;
    
    //设置selectedbutton的frame
    CGFloat selectedButtonX = self.imageButton.frame.size.width - selectedButtonWH  ;
    CGFloat selectedButtonY = 0;
    self.selectedButton.frame = CGRectMake ( selectedButtonX , selectedButtonY , selectedButtonWH, selectedButtonWH);
}

@end
