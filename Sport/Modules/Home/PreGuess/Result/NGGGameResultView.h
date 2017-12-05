//
//  NGGGameResultView.h
//  Sport
//
//  Created by Jan on 21/11/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol NGGGameResultViewDelegate <NSObject>

- (void)loadMoreGameResultInfo;
- (void)refreshGameResultInfo;

@end

@interface NGGGameResultView : UIView

@property (nonatomic, strong) NSArray *arrayOfGameResult;

@property (nonatomic, weak) id <NGGGameResultViewDelegate> delegate;

@end
