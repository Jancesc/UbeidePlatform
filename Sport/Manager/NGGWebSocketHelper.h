//
//  NGGWebSocketHelper.h
//  Sport
//
//  Created by Jan on 05/12/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NGGWebSocketHelperDelegate

//连接成功
- (void)openSuccess;
//连接断开
- (void)closeSuccess;

//无法连接服务器
- (void)connectedFailed;

@end

@interface NGGWebSocketHelper : NSObject

@property (nonatomic, strong) NSString *urlString;

@property (nonatomic, strong) UIViewController <NGGWebSocketHelperDelegate> *delegate;

+ (NGGWebSocketHelper *) shareHelper;

- (void)webSocketOpen;

- (void)webSocketClose;

- (void)sendData:(id)data;


@end
