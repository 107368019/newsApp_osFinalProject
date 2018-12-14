//
//  newsReq.h
//  finalProject
//
//  Created by taizhou on 2018/12/11.
//  Copyright © 2018 taizhou. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface newsReq : NSObject

@property (strong,nonatomic) NSString *accountID;
@property (assign,nonatomic) int lastIndex;
@property (assign,nonatomic) int count;
@property (strong,nonatomic) NSArray *type;
-(id)initWithaccountID:(NSString *)accountID_
             lastIndex:(int )lastIndex_
                  count:(int)count_
                  type:(NSArray*)type_;
- (NSMutableDictionary *)toNSDictionary;
@end


