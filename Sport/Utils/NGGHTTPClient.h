//
//  NGGHTTPClient.h
//
//  Created by Jan on 4/5/16.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef enum
{
    NGGErrorCodeHttpResponseNetworkError = 0,
    NGGErrorCodeHttpResponseJSONError
} NGGHttpResponseError;

#define LOG_DATA(d) NSLog(@"%@", [[NSString alloc] initWithData:(d) encoding:NSUTF8StringEncoding])
static NSString *const NGGHttpResponseErrorDomain = @"NGGHttpErrorDomain";

@interface NGGHTTPClient : NSObject

@property (nonatomic, strong) NSString *baseURL;

+ (NGGHTTPClient *)defaultClient;

- (AFNetworkReachabilityStatus)currentNetworkStatus;

//API Request Methods
- (void) getPath:(NSString *)path parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) postPath:(NSString *)path parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) postPath:(NSString *)path parameters:(id)parameters willContainsLoginSession:(BOOL) willContainsLoginSession success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) postPath:(NSString *)path parameters:(id)parameters constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
