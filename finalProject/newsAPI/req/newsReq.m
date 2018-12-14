//
//  newsReq.m
//  finalProject
//
//  Created by taizhou on 2018/12/11.
//  Copyright © 2018 taizhou. All rights reserved.
//

#import "newsReq.h"

@implementation newsReq
-(id)initWithaccountID:(NSString *)accountID_
             lastIndex:(int )lastIndex_
                 count:(int)count_
                  type:(NSArray*)type_{
    self = [super init];
    if (self) {
        _accountID=accountID_;
        _lastIndex=lastIndex_;
        _count=count_;
        _type=type_;
    }
    return self;
}

- (NSMutableDictionary *)toNSDictionary{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:_accountID forKey:@"accountID"];
    [dictionary setValue:[NSNumber numberWithDouble:_lastIndex] forKey:@"lastIndex"];
    [dictionary setValue:[NSNumber numberWithDouble:_count] forKey:@"count"];
    [dictionary setValue:_type forKey:@"type"];
    return dictionary;
}

@end
