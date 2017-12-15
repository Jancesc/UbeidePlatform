//
//  NGGGameListView.h
//  Sport
//
//  Created by Jan on 30/11/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NGGGameListModel.h"
#import "NGGLeagueModel.h"
#import "NGGGuessListViewController.h"

@protocol NGGGameListViewDelegate <NSObject>

- (void)gameListViewDidSelectCellWithModel:(NGGGameListModel *)model;

@end

@interface NGGGameListView : UIView

@property (nonatomic, weak) NGGGuessListViewController <NGGGameListViewDelegate> *delegate;
@property (nonatomic, weak) NGGGuessListViewController *superController;

@end
