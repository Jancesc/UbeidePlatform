//
//  NGGCommonViewController.h
//  shelves
//
//  Created by Jan on 08/08/2017.
//  Copyright © 2017 niugaga. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NGGCommonViewController : UIViewController

//Message Methods
- (void) showLoadingHUDWithText:(NSString *) text;
- (void) dismissHUD;
- (void) showSuccessHUDWithText:(NSString *) text;
- (void) showSuccessHUDWithText:(NSString *)text duration:(float) duration;
- (void) showErrorHUDWithText:(NSString *) text;
- (void) showErrorHUDWithText:(NSString *) text duration:(float) duration;
- (void) showAlertText:(NSString *) text completion:(void (^)(void)) completion;

//Handle Network Error
- (void) installNetworkErrorTipsViewOn:(UIView *) view;

//Loading Text Methods
- (void) showLoadingLabelWithText:(NSString *) text;
- (void) dismissLoadingLabel;

- (void) showAnimationLoadingHUDWithText:(NSString *)text;
- (void) dismissAnimationLoadingHUD;

- (void) showAnimationLoadingHUDWithText:(NSString *)text onView:(UIView *) view;
- (void) dismissAnimationLoadingHUDOnView:(UIView *) view;

//API Request Methods
- (void) getPath:(NSString *)path parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) postPath:(NSString *)path parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void)postPath:(NSString *)path parameters:(NSDictionary *)parameters willContainsLoginSession:(BOOL)willContainsLoginSession success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) postPath:(NSString *)path parameters:(id)parameters constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

//API Response Data Parse Methods
- (NSDictionary *) dictionaryData:(id) responseJSONObject errorHandler:(void (^)(NSInteger code, NSString *msg)) handler;
- (NSArray *) arrayData:(id) responseJSONObject errorHandler:(void (^)(NSInteger code, NSString *msg)) handler;
- (BOOL) noData:(id) responseJSONObject errorHandler:(void (^)(NSInteger code, NSString *msg)) handler;

//
- (void)presentLoginViewControllerWithAlertView;
- (void)presentLoginViewController;


// show EmptyView
- (void)showEmptyViewInView:(UIView *)view;

@end
