//
//  newsDecoder.m
//  finalProject
//
//  Created by taizhou on 2018/12/11.
//  Copyright © 2018 taizhou. All rights reserved.
//

#import "jsonDecoder.h"
#import "NSObject+ObjectCategory.h"

@implementation jsonDecoder

+ (newsRes *)getNewsDecoder:(NSData *)data{
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    newsRes *res=[newsRes new];
    res.status=[[parsedObject valueForKey:@"status"]intValue];
    
    NSDictionary * contentsDic=[[parsedObject valueForKey:@"results"]valueForKey:@"content"];
    for (NSDictionary *contentDic in contentsDic){
        content_newsReq *content=[content_newsReq new];
        [content parseJsonByDic:contentDic];
        [res.results.content addObject:content];
    }   
    
    return res;
}

@end
