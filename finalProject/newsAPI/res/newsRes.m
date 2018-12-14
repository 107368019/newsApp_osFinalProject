//
//  newsRes.m
//  finalProject
//
//  Created by taizhou on 2018/12/11.
//  Copyright © 2018 taizhou. All rights reserved.
//

#import "newsRes.h"

@implementation newsRes
-(instancetype)init{
    if (self = [super init]){
        _results= [result_newsReq new ];
    }
    return self;
}
@end

@implementation result_newsReq
-(instancetype)init{
    if (self = [super init]){
        _content= [NSMutableArray<content_newsReq*> new ];
    }
    return self;
}
@end

@implementation content_newsReq


@end
