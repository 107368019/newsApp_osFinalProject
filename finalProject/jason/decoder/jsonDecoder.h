//
//  newsDecoder.h
//  finalProject
//
//  Created by taizhou on 2018/12/11.
//  Copyright © 2018 taizhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "newsRes.h"


@interface jsonDecoder : NSObject
+ (newsRes *)getNewsDecoder:(NSData *)data;
@end


