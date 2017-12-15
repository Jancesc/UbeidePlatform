//
//  NGGGuessSectionModel.h
//  Sport
//
//  Created by Jan on 12/12/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGModel.h"
#import "NGGGuessItemModel.h"
#import "NGGEnum.h"

@interface NGGGuessSectionModel : NGGModel

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, assign) NGGGuessDetailCellType itemCellType;

@property (nonatomic,strong) NSArray <NGGGuessItemModel *> *arrayOfItem;
@end
