//
//  newsRes.h
//  finalProject
//
//  Created by taizhou on 2018/12/11.
//  Copyright © 2018 taizhou. All rights reserved.
//

#import <Foundation/Foundation.h>
@class result_newsReq,content_newsReq;


@interface newsRes : NSObject

@property (assign,nonatomic) int status;
@property (strong,nonatomic) result_newsReq *results;
-(instancetype)init;
@end

@interface result_newsReq : NSObject

@property (assign,nonatomic) int count;
@property (strong,nonatomic) NSMutableArray<content_newsReq* >* content;
-(instancetype)init;
@end

@interface content_newsReq : NSObject

@property (assign,nonatomic) int type;
@property (strong,nonatomic) NSString* url;
@property (strong,nonatomic) NSString* imageUrl;
@property (strong,nonatomic) NSString* title;
@property (strong,nonatomic) NSString* content;
@property (assign,nonatomic) int index;
@property (strong,nonatomic) NSString* publisher;

@end
