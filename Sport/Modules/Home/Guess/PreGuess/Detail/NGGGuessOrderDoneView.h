//
//  NGGGuessOrderDoneView.h
//  Sport
//
//  Created by Jan on 13/12/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NGGGuessOrderDoneViewDelegate <NSObject>

- (void)guessOrderDoneViewDidClickAdditionButton;

@end

@interface NGGGuessOrderDoneView : UIView

@property (nonatomic, strong) id <NGGGuessOrderDoneViewDelegate> delegate;

- (void)updateGuessOrderDoneViewWithInfo:(NSDictionary *)info;

@end
