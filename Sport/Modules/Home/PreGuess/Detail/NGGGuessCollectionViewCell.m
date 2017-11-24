//
//  NGGGuessCollectionViewCell.m
//  Sport
//
//  Created by Jan on 08/11/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGGuessCollectionViewCell.h"

@implementation NGGGuessCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.cornerRadius = 4.f;
    self.layer.masksToBounds = YES;
}

@end
