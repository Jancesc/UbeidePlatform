//
//  NGGHTTPClient.m
//
//  Created by Jan on 4/5/16.
//

#import "NGGHTTPClient.h"
#import "EncodingTools.h"

#pragma mark - Constants Definition

#define BASE_URL @"http://wx7.bigh5.com/fb/web"
#define APPKEY @"kk8hp2wet3bmz1q7w2d9gj1l6s2"

@interface NGGHTTPClient ()
{
    AFHTTPSessionManager *_manager;
}
@end

@implementation NGGHTTPClient

- (instancetype) init {
    
    if (self = [super init]) {
        
        _manager = [[AFHTTPSessionManager manager] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
        _manager.responseSerializer.acceptableContentTypes = nil;//[NSSet setWithObject:@"text/ plain"];
        _manager.securityPolicy = [AFSecurityPolicy defaultPolicy];
        _manager.securityPolicy.allowInvalidCertificates = YES;//忽略https证书
        _manager.securityPolicy.validatesDomainName = NO;//是否验证域名
        
        //请求参数序列化类型
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        //响应结果序列化类型
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _baseURL = BASE_URL;
    }
    return self;
}

+ (NGGHTTPClient *)defaultClient {
    
    static NGGHTTPClient *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
      
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (void)dealloc {
    
    [_manager invalidateSessionCancelingTasks:YES];
}

- (BOOL) netWorkReachabilityWithURLString:(NSString *) strUrl
{
    __block BOOL netState = NO;
    
    [_manager.reachabilityManager startMonitoring];
    [_manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                netState = YES;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                netState = NO;
            default:
                break;
        }
    }];
    
    return netState;
}

#pragma mark - HTTP REQUEST METHODS

- (void) getPath:(NSString *)path  parameters:(NSDictionary *)parameters success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    NSString *absolutePath = [path hasPrefix:@"http"] ? path : [NSString stringWithFormat:@"%@%@", _baseURL, path];
    
    [_manager GET:absolutePath parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSError *error = nil;
        
        id jsonObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
        if (nil == jsonObj) {
            //JSON解释错误
            NSLog(@"JSON DECODE ERROR. %@", error);
            LOG_DATA(responseObject);
            
            failure(task, [[NSError alloc] initWithDomain:NGGHttpResponseErrorDomain code:NGGErrorCodeHttpResponseNetworkError userInfo:nil]);
            return ;
        }
        success(task, jsonObj);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //网络错误
        failure(task,[[NSError alloc] initWithDomain:NGGHttpResponseErrorDomain code:NGGErrorCodeHttpResponseNetworkError userInfo:nil]);
    }];
    
}

- (void) postPath:(NSString *)path  parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    NSString *absolutePath = [path hasPrefix:@"http"] ? path : [NSString stringWithFormat:@"%@%@", _baseURL, path];
    [_manager POST:absolutePath parameters:[self signedParametersWithParameters:parameters]progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSError *error = nil;
        id jsonObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
        if (nil == jsonObj) {
            
            //JSON解释错误
            NSLog(@"JSON DECODE ERROR. %@", [[NSError alloc] initWithDomain:NGGHttpResponseErrorDomain code:NGGErrorCodeHttpResponseNetworkError userInfo:nil]);
            LOG_DATA(responseObject);
            failure(task, error);
        }
        success(task, jsonObj);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(task,[[NSError alloc] initWithDomain:NGGHttpResponseErrorDomain code:NGGErrorCodeHttpResponseNetworkError userInfo:nil]);
        NSLog(@"%@", error);
    }];
}

- (void) postPath:(NSString *)path  parameters:(id)parameters willContainsLoginSession:(BOOL) willContainsLoginSession success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    
    NGGLoginSession *session = [NGGLoginSession activeSession];
    NSMutableDictionary *inputParams = nil == parameters ? [NSMutableDictionary dictionary] : [parameters mutableCopy];
    
    if (session && willContainsLoginSession) {
        [inputParams setObject:session.currentUser.token forKey:@"token"];
        [inputParams setObject:session.currentUser.uid forKey:@"uid"];
    }

    [self postPath:path parameters:inputParams success:success failure:failure];
}

- (void) postPath:(NSString *)path parameters:(id)parameters constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    
    NGGLoginSession *session = [NGGLoginSession activeSession];
    NSMutableDictionary *inputParams = nil == parameters ? [NSMutableDictionary dictionary] : [parameters mutableCopy];
    
    if (session) {
        [inputParams setObject:session.currentUser.token forKey:@"token"];
        [inputParams setObject:session.currentUser.uid forKey:@"uid"];
    }
    NSString *absolutePath = [path hasPrefix:@"http"] ? path : [NSString stringWithFormat:@"%@%@", _baseURL, path];
    
    
    [_manager POST:absolutePath parameters:[self signedParametersWithParameters:inputParams] constructingBodyWithBlock:block progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSError *error = nil;
        id jsonObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
        if (jsonObj == nil)
        {
            //JSON解释错误
            NSLog(@"JSON DECODE ERROR. %@", error);
            LOG_DATA(responseObject);
            failure(task, [[NSError alloc] initWithDomain:NGGHttpResponseErrorDomain code:NGGErrorCodeHttpResponseJSONError userInfo:nil]);
            return ;
        }
        success(task,jsonObj);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //网络错误
        NSLog(@"%@", error);
        failure(task, [[NSError alloc] initWithDomain:NGGHttpResponseErrorDomain code:NGGErrorCodeHttpResponseNetworkError userInfo:nil]);
    }];      
}

- (NSDictionary *) signedParametersWithParameters:(NSDictionary *) parameters {
    
    NSMutableDictionary *params = parameters != nil ? [parameters mutableCopy] : [NSMutableDictionary dictionary];
    NSUInteger ts = (NSUInteger)[[NSDate date] timeIntervalSince1970];
    [params setObject:@(ts) forKey:@"time"];
    NSString *appKey = APPKEY;
    [params setObject:appKey forKey:@"app_key"];
    NSArray *allKeys = [params allKeys];
    NSArray *sortedKeys = [allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    NSMutableString *mString = [[NSMutableString alloc] init];
    for (NSString *paramKey in sortedKeys) {
        NSString *paramVal = [params objectForKey:paramKey];
        [mString appendFormat:@"%@=%@&", URLEncodeString(paramKey), URLEncodeString([paramVal description])];
    }
    NSString *concatParams = [mString substringToIndex:[mString length]-1];
    NSString *sign = MD5HexDigest(concatParams);
    [params removeObjectForKey:@"app_key"];
    [params setObject:sign forKey:@"sign"];
    NSLog(@"%@", params);
    return params;
}
@end
