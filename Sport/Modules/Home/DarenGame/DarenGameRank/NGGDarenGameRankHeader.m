//
//  NGGDarenGameRankHeader.m
//  Sport
//
//  Created by Jan on 08/02/2018.
//  Copyright © 2018 NGG. All rights reserved.
//

#import "NGGDarenGameRankHeader.h"
#import "UIImageView+WebCache.h"
@interface NGGDarenGameRankHeader() {
    
    __weak IBOutlet UIImageView *_rankImageView;
    __weak IBOutlet UIImageView *_avatarImageView;
    __weak IBOutlet UILabel *_nameLabel;
    __weak IBOutlet UILabel *_timesLabel;
    __weak IBOutlet UILabel *_rankLabel; 
}

@end

@implementation NGGDarenGameRankHeader

-(void)setInfo:(NSDictionary *)info {
    
    _info = info;
    
//    "total": "-7900",
//    "nickname": "啊啊啊实打实",
//    "avatar_img": "http://wx7.bigh5.com/fb/web/uploads/1712/011445398939.png",
//    "rank": "2"
    
    
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:[info stringForKey:@"avatar_img"]] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    
    _nameLabel.text = [info stringForKey:@"nickname"];
    _timesLabel.text = [info stringForKey:@"total"];
    NSInteger rank = [info intForKey:@"rank"];
    if (rank < 4) {
        
        _rankLabel.hidden = YES;
        _rankImageView.hidden = NO;
        NSString *imageStr = [NSString stringWithFormat:@"rank%ld", rank];
        _rankImageView.image = [UIImage imageNamed:imageStr];
    } else {
        
        _rankLabel.hidden = NO;
        _rankImageView.hidden = YES;
        _rankLabel.text = @(rank).stringValue;
    }
}

@end
