//
//  NGGWebSocketHelper.h
//  Sport
//
//  Created by Jan on 05/12/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NGGWebSocketHelper : NSObject

@property (nonatomic, strong) NSString *urlString;
+ (NGGWebSocketHelper *) shareHelper;

- (void)SRWebSocketOpen;
@end
