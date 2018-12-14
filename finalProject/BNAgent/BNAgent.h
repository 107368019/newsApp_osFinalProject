//
//  apiAgent.h
//  finalProject
//
//  Created by taizhou on 2018/12/12.
//  Copyright © 2018 taizhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "jsonDecoder.h"
#import "jsonEncoder.h"

@protocol BNAgentDelegate <NSObject>
@optional
- (void)resInfo:(id)Res pushName:(NSString *)name;
@end
@interface BNAgent : NSObject
@property (nonatomic, weak) id<BNAgentDelegate> delegate;
- (void)getNews:(newsReq *)req requestTime:(int)requestTime;
@end


