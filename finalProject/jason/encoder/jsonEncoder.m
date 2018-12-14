//
//  jsonEncoder.m
//  finalProject
//
//  Created by taizhou on 2018/12/12.
//  Copyright © 2018 taizhou. All rights reserved.
//

#import "jsonEncoder.h"

@implementation jsonEncoder

+ (NSData *)Encoder:(id)Req{
    
    if ([NSJSONSerialization isValidJSONObject:[Req toNSDictionary]])
    {
        NSData *verifyData =  [NSJSONSerialization dataWithJSONObject:[Req toNSDictionary] options:0 error:nil];       
        return verifyData;
    }
    return nil;
}

@end
