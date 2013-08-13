//
//  ApiUtil.h
//
//
//  Created by 黒木裕貴 on 12/03/28.
//  Copyright (c) 2012年 ykuroki All rights reserved.
//


#import "ApiUtil.h"

@implementation ApiUtil

/*
 * allyApi へリクエストを送り、レスポンスの文字列を返す
 */
+(NSString *)getResponseOnRequest:(NSString *)requestUrl
                           params:(NSMutableDictionary *)params
                           method:(NSString *)method
{
    // リクエスト情報を初期化する
    NSURL *url = [NSURL URLWithString:requestUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:method];
    
    // パラメータをまとめる
    NSString *param = @"";
    id key;
    for (key in [params allKeys]) {
        // value を URL エンコードする
        NSString *value = ((__bridge_transfer NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
            (__bridge CFStringRef)[params objectForKey:key],
            NULL,
            (CFStringRef)@"!*'();:@&=+$,/?%#[]",
            kCFStringEncodingUTF8));
        
        
        // key=value 形式にまとめる
        if (param.length > 0) param = [param stringByAppendingFormat:@"&"];
        param = [param stringByAppendingFormat:@"%@=%@", key, value];
        value = nil;
    }
    [request setHTTPBody:[param dataUsingEncoding:NSUTF8StringEncoding]];
    
    // リクエストを送る
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    // レスポンスを文字列にする
    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    return responseString;
}

/*
 * 指定されたURLへリクエストを送る
 */
+(AFHTTPClient *)requestToUrl:(NSString *)requestUrl
                       params:(NSMutableDictionary *)params
                       method:(NSString *)method
                      success:(AFHTTPRequestSuccessBlocks)success
                      failure:(AFHTTPRequestFailureBlocks)failure
{
    // URL がからの場合は何もしない
    if (!requestUrl) return nil;
    
    // キャッシュをクリアする
    NSURLCache *cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    
    // URL 情報を初期化する
    NSURL *url = [NSURL URLWithString:requestUrl];
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:url];
    
    // リクエストを送る
    if ([method isEqualToString:@"POST"]) {
        [client postPath:@"" parameters:params success:success failure:failure];
    } else{
        [client getPath:@"" parameters:params success:success failure:failure];
    }
    
    return client;
}

/*
 * 指定されたURLへ Multipart リクエストを送る
 */
+(AFHTTPRequestOperation *)multipartRequestToUrl:(NSString *)requestUrl
                                          params:(NSMutableDictionary *)params
                                          method:(NSString *)method
                                         success:(AFHTTPRequestSuccessBlocks)success
                                         failure:(AFHTTPRequestFailureBlocks)failure
                                         dataSet:(NSDictionary *)dataSet
{
    NSURL *url = [NSURL URLWithString:requestUrl];
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:url];
    
    // パラメータ情報をまとめる
    NSString *key;
    NSURLRequest *request = [client multipartFormRequestWithMethod:@"POST" path:@"" parameters:params constructingBodyWithBlock:^(id <AFMultipartFormData>formData) {
        for (key in [dataSet allKeys]) {
            NSData *imageData = UIImageJPEGRepresentation(
                                                  [[UIImage alloc]
                                                   initWithData:[[dataSet objectForKey:key] 
                                                                 objectForKey:@"image"]],
                                                  1);
            NSString *fileName = [[dataSet objectForKey:key] objectForKey:@"filename"];
            [formData appendPartWithFileData:imageData name:@"image" fileName:fileName mimeType:@"image/jpeg"];
        }
    }];
    
    // operation
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:success failure:failure];
    [operation start];
    
    return operation;
}


/*
 * AFHTTPClient のレスポンスを JSON として解析する
 */
+(NSDictionary *)parseToJson:(NSData *)response
{
    NSString *body = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    return [jsonParser objectWithString:body];
}

@end