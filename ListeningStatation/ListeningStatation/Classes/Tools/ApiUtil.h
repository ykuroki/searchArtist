//
//  ApiUtil.h
//
//
//  Created by 黒木裕貴 on 12/03/28.
//  Copyright (c) 2012年 ykuroki All rights reserved.
//

#import "SBJson.h"
#import "AFNetworking.h"

@interface ApiUtil : NSObject

typedef void (^AFHTTPRequestSuccessBlocks)(AFHTTPRequestOperation *, NSDictionary *);
typedef void (^AFHTTPRequestFailureBlocks)(AFHTTPRequestOperation *, NSError *);

+(NSString *)getResponseOnRequest:(NSString *)requestUrl
                           params:(NSMutableDictionary *)params
                           method:(NSString *)method;

+(AFHTTPClient *)requestToUrl:(NSString *)requestUrl
                       params:(NSMutableDictionary *)params
                       method:(NSString *)method
                      success:(AFHTTPRequestSuccessBlocks)success
                      failure:(AFHTTPRequestFailureBlocks)failure;

+(AFHTTPRequestOperation *)multipartRequestToUrl:(NSString *)requestUrl
                                          params:(NSMutableDictionary *)params
                                          method:(NSString *)method
                                         success:(AFHTTPRequestSuccessBlocks)success
                                         failure:(AFHTTPRequestFailureBlocks)failure
                                         dataSet:(NSDictionary *)dataSet;

+(NSDictionary *)parseToJson:(NSData *)response;

@end
