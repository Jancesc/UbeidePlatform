//
//  NGGShopClassifyCollectionViewCell.m
//  Sport
//
//  Created by Jan on 06/12/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGShopClassifyCollectionViewCell.h"

@interface NGGShopClassifyCollectionViewCell () {
    
    __weak IBOutlet UILabel *_titleLabel;
    __weak IBOutlet UIView *_tipsView;
}

@end
@implementation NGGShopClassifyCollectionViewCell

- (void)setCellInfo:(NSDictionary *)cellInfo {
    
    _cellInfo = cellInfo;
    _titleLabel.text = [cellInfo stringForKey:@"classify_name"];
}

- (void)setSelected:(BOOL)selected {
    
    [super setSelected:selected];
    _titleLabel.textColor = selected ? NGGPrimaryColor : NGGColor333;
    _tipsView.hidden = !selected;
}

@end
