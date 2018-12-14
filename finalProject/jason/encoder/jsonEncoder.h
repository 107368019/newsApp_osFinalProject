//
//  jsonEncoder.h
//  finalProject
//
//  Created by taizhou on 2018/12/12.
//  Copyright © 2018 taizhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "newsReq.h"


@interface jsonEncoder : NSObject
+ (NSData *)Encoder:(id)Req;
@end


