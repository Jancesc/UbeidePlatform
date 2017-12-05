//
//  NGGRankView.h
//  Sport
//
//  Created by Jan on 21/11/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NGGRankViewDelegate <NSObject>

- (void)refreshRankInfo;

@end
@interface NGGRankView : UIView

@property (nonatomic, strong) NSDictionary *rankDict;

@property (nonatomic, weak) id <NGGRankViewDelegate> delegate;

@end
