//
//  NGGHomePageMenuCollectionViewCell.m
//  sport
//
//  Created by Jan on 26/10/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGHomePageMenuCollectionViewCell.h"

@interface NGGHomePageMenuCollectionViewCell ()

@end

@implementation NGGHomePageMenuCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)munuButtonClicked:(UIButton *)button {
    
    if (_pageTappedHandler) {
        
        _pageTappedHandler(button.tag);
    }
}


@end
