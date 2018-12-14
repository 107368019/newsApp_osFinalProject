//
//  DataManager.h
//  finalProject
//
//  Created by taizhou on 2018/12/12.
//  Copyright © 2018 taizhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNAgent.h"
#import "MethodResponse.h"
NS_ASSUME_NONNULL_BEGIN

@interface DataManager : NSObject<BNAgentDelegate>
+ (id)getInstance;
- (void)getNews:(newsReq *)req;
@end

NS_ASSUME_NONNULL_END
