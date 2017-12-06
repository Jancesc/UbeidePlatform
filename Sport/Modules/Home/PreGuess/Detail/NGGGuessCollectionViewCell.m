//
//  NGGGuessCollectionViewCell.m
//  Sport
//
//  Created by Jan on 08/11/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGGuessCollectionViewCell.h"

@interface NGGGuessCollectionViewCell() {
    
    __weak IBOutlet UILabel *_titleLabel;
    __weak IBOutlet UIView *_disableVIew;
}

@end

@implementation NGGGuessCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.cornerRadius = 4.f;
    self.layer.masksToBounds = YES;
}

@end
