//
//  NGGRankHeaderView.m
//  Sport
//
//  Created by Jan on 22/11/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGRankHeaderView.h"
#import "UIImageView+WebCache.h"

@interface NGGRankHeaderView () {
    
    __weak IBOutlet UIImageView *_avatarImageView;
    __weak IBOutlet UILabel *_coinLabel;
    __weak IBOutlet UILabel *_rankLabel;
    __weak IBOutlet UILabel *_nameLabel;
}

@end;

@implementation NGGRankHeaderView

-(void)setInfo:(NSDictionary *)info {
    
    _info = info;
    
    NSString *imageString = [info stringForKey:@"avatar_img"];
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    _coinLabel.text = [info stringForKey:@"total"];
    _nameLabel.text = [info stringForKey:@"nickname"];
    _rankLabel.text = [NSString stringWithFormat:@"七日盈利:%@", [info stringForKey:@"rank"]];
}

@end
