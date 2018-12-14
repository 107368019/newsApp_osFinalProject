//
//  MethodResponse.h
//  finalProject
//
//  Created by taizhou on 2018/12/12.
//  Copyright © 2018 taizhou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MethodResponse : NSObject

@property (strong, nonatomic) NSString* methodName;
@property (strong, nonatomic) NSObject* object;

@end

NS_ASSUME_NONNULL_END
