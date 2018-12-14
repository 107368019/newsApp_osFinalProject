//
//  apiAgent.m
//  finalProject
//
//  Created by taizhou on 2018/12/12.
//  Copyright © 2018 taizhou. All rights reserved.
//

#import "BNAgent.h"

@implementation BNAgent

- (void)getNews:(newsReq *)req requestTime:(int)requestTime{
    
    NSString *apiString = [NSString stringWithFormat:@"https://api-dev.bluenet-ride.com/v2_0/lineBot/news/get"];
    NSURL *url = [NSURL URLWithString:apiString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[jsonEncoder Encoder:req]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [self sendHttpRequest:request completeHandle:^(NSData *resData, NSError *resErr) {
        
        newsRes *res = [newsRes new];
        if (resErr)
        {
            if (requestTime == 4)
            {
                res.status = 3;
                [self sendRes:res toDelegateNameIs:@"getNews"];
            }
            else
                [self getNews:req requestTime:requestTime+1];
        }
        else
        {
            res = [jsonDecoder getNewsDecoder:resData];
            [self sendRes:res toDelegateNameIs:@"getNews"];
        }
    }];
}

- (void)sendHttpRequest:(NSMutableURLRequest *)request completeHandle:(void(^)(NSData *resData, NSError *resErr))handler{
    
    NSURLSession *sess = [BNAgent sharedSession];
    NSURLSessionDataTask *task = [sess dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSHTTPURLResponse *res = (id)response;
        
        if (error)
            handler(nil,error);
        else if ([res statusCode] != 200)
        {
            NSError *err =[NSError errorWithDomain:[res.URL host] code:[res statusCode] userInfo:@{@"msg":@"http status error"}];
            handler(nil,err);
        }
        else if(data)
            handler(data,nil);
        else
        {
            NSError *err =[NSError errorWithDomain:[res.URL host] code:[res statusCode] userInfo:@{@"msg":@"data is nil"}];
            handler(nil,err);
        }
    }];
    
    [task resume];
}

+ (NSURLSession *)sharedSession {
    static NSURLSession *sess = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.HTTPMaximumConnectionsPerHost = 10;
        sess = [NSURLSession sessionWithConfiguration:config];
    });
    return sess;
}

- (void)sendRes:(id)res toDelegateNameIs:(NSString *)name{
    
    if ([self.delegate respondsToSelector:@selector(resInfo:pushName:)])
    {
        [self.delegate resInfo:res pushName:name];
    }
}

@end
