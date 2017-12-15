//
//  NGGGuessItemModel.h
//  Sport
//
//  Created by Jan on 12/12/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGModel.h"

@interface NGGGuessItemModel : NGGModel

@property (nonatomic,strong) NSString *itemID;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *odds;

@property (nonatomic,assign) BOOL isGuessed;

@end
