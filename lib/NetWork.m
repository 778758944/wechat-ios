//
//  NetWork.m
//  WeChat
//
//  Created by Tom Xing on 8/22/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "NetWork.h"
#import <unistd.h>
#import <UIKit/UIKit.h>

NSErrorDomain const NSUserNetWorkCustomDomain = @"NSUserNetWorkCustomDomain";

@interface NetWork()
@property(nonatomic, strong) NSURLSession * session;
@property(nonatomic, strong) NSURL * baseUrl;
@end

@implementation NetWork

static NetWork * _net = nil;

+(instancetype) sharedNetWork
{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        _net = [[super allocWithZone:NULL] init];
    });
    return _net;
}

+(id) allocWithZone:(struct _NSZone *)zone
{
    return [NetWork sharedNetWork];
}

-(id) copyWithZone: (struct _NSZone *)zone
{
    return [NetWork sharedNetWork];
}

-(NSURLSession *) session
{
    if (!_session) {
        _session = [NSURLSession sharedSession];
    }
    return _session;
}

-(NSURL *) baseUrl
{
    if (!_baseUrl) {
        _baseUrl = [NSURL URLWithString:HTTP];
    }
    
    return _baseUrl;
    
}

-(void) postWithUrl: (NSString *) url Data: (NSDictionary *) data completion:(void(^)(NSError * err, NSDictionary * response)) handle
{
    NSURL * requestUrl = [self.baseUrl URLByAppendingPathComponent:url];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:requestUrl];
    [request setHTTPMethod:@"POST"];
    
    if (data) {
        NSString * requestData = [self transformDictionary:data];
        NSData * bodyData = [requestData dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:bodyData];
    }
    
    NSURLSessionDataTask * task = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            [self.delegate alertWithTitle:@"Error" Message:error.localizedDescription];
            handle(error, nil);
        } else {
            NSError * jsonErr;
            NSDictionary * jsonData;
            if (data.length) {
                jsonData = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:&jsonErr];
            }
            
            if (jsonErr) {
                [self.delegate alertWithTitle:@"Error" Message:jsonErr.localizedDescription];
                handle(jsonErr, nil);
            } else {
                if (jsonData[@"error"]) {
                    NSDictionary<NSErrorUserInfoKey, id> * userinfo = @{
                            NSLocalizedDescriptionKey: jsonData[@"error"][@"message"],
                    };
                    NSNumber * code = jsonData[@"error"][@"statusCode"];
                    NSError * userErr = [NSError errorWithDomain:NSUserNetWorkCustomDomain code:code.integerValue userInfo: userinfo];
                    handle(userErr, jsonData);
                } else {
                    handle(nil, jsonData);
                }
            }
        }
    }];
    [task resume];
}

-(NSString *) transformDictionary: (NSDictionary *) dic
{
    NSString * data = @"";
    int i = 0;
    for (NSString * key in dic) {
        NSLog(@"%@ = %@", key, dic[key]);
        if (i > 0) {
            data = [data stringByAppendingFormat:@"&%@=%@", key, dic[key]];
        } else {
            data = [data stringByAppendingFormat:@"%@=%@", key, dic[key]];
        }
        i++;
    }
    NSLog(@"data = %@", data);
    return data;
}

-(void) postImageWithUrl: (NSString *) url Data: (NSDictionary *) data completion: (void(^)(NSError * err, NSDictionary * response)) handle
{
    NSString * DATABOUNARY = @"WC_DATA_BOUNARY";
    NSString * requestStr = [HTTP stringByAppendingString: url];
    NSURL * requestUrl = [[NSURL alloc] initWithString:requestStr];
    NSMutableURLRequest * multiRequest = [[NSMutableURLRequest alloc] initWithURL: requestUrl];
    
    multiRequest.HTTPMethod = @"POST";
    NSString * boundary = [NSString stringWithFormat:@"--%@", DATABOUNARY];
    NSString * endBoundary = [NSString stringWithFormat:@"--%@--", DATABOUNARY];
    
    UIImage * image = data[@"data"];
    NSData * imageData = UIImageJPEGRepresentation(image, 0.3);
    NSMutableString *body = [NSMutableString string];
    NSMutableData * requestData = [NSMutableData data];
    [body appendFormat:@"%@\r\n", boundary];
    [body appendFormat:@"Content-Disposition: form-data; name=\"data\"; filename=\"avator.jpg\"\r\n"];
    [body appendFormat:@"Content-Type: image/jpeg\r\n\r\n"];
    
    [requestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    [requestData appendData:imageData];
    NSString * bodyEnd = [NSString stringWithFormat:@"\r\n%@\r\n", endBoundary];
    [requestData appendData:[bodyEnd dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString * content = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", DATABOUNARY];
    
    [multiRequest setValue:content forHTTPHeaderField:@"Content-Type"];
    [multiRequest setValue:[NSString stringWithFormat:@"%lu", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    
    [multiRequest setHTTPBody:requestData];
    NSURLSessionTask * task = [self.session dataTaskWithRequest:multiRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            [self.delegate alertWithTitle:@"Error" Message:error.localizedDescription];
            handle(error, nil);
        } else {
            NSDictionary * jsonData;
            NSError * serialErr;
            if (data.length) {
                jsonData = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error:&serialErr];
            }
            
            if (serialErr) {
                [self.delegate alertWithTitle:@"Error" Message:serialErr.localizedDescription];
                handle(serialErr, nil);
            } else {
                handle(nil, jsonData);
            }
        }
    }];
    
    [task resume];
    
    
}



@end
