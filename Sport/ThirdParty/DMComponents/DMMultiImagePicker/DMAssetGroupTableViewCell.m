//
//  DMAssetGroupTableViewCell.m
//  DMMultiImagePicker
//
//  Created by Damai on 15/9/11.
//  Copyright (c) 2015年 Damai. All rights reserved.
//

#import "DMAssetGroupTableViewCell.h"

@implementation DMAssetGroupTableViewCell



- (void)layoutSubviews
{
    
    [ super layoutSubviews ];
    self.imageView.frame = CGRectMake( 1 , 0 , self.imageView.frame.size.width , self.imageView.frame.size.height );
    self.textLabel.frame = CGRectMake( 10 + self.imageView.frame.size.width , self.textLabel.frame.origin.y , self.textLabel.frame.size.width,  self.textLabel.frame.size.height );

}

@end
