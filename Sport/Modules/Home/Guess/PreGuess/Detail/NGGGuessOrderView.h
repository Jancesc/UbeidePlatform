//
//  NGGGuessOrderView.h
//  Sport
//
//  Created by Jan on 13/12/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NGGGuessItemModel.h"
#import "NGGGuessSectionModel.h"

@protocol NGGGuessOrderViewDelegate <NSObject>

- (void)guessOrderViewDidClickRechargeButton;

- (void) guessOrderViewMakeOrder:(NSString *)count itemModel:(NGGGuessItemModel *)itemModel sectionModel:(NGGGuessSectionModel *)sectionModel;

@end

@interface NGGGuessOrderView : UIView

- (void) updateWithItemModel:(NGGGuessItemModel *)itemModel sectionModel:(NGGGuessSectionModel *)sectionModel;
- (NGGGuessItemModel *) currentItemModel;
@property (nonatomic, strong) id <NGGGuessOrderViewDelegate> delegate;
@end
