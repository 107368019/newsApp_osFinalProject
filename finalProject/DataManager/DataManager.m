//
//  DataManager.m
//  finalProject
//
//  Created by taizhou on 2018/12/12.
//  Copyright © 2018 taizhou. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager
BNAgent* bnAgent;
static DataManager *dataManagerInstance = nil;
+ (DataManager *)getInstance{
    if (dataManagerInstance == nil) {
        dataManagerInstance = [[super allocWithZone:NULL] init];
        bnAgent = [BNAgent alloc];
    }
    return dataManagerInstance;
}

- (void)resInfo:(id)Res pushName:(NSString *)name{
    
    MethodResponse *methodResponse = [[MethodResponse alloc] init];
    methodResponse.methodName = name;
    methodResponse.object = Res;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dataManager" object:methodResponse];
}

- (void)getNews:(newsReq *)req{
    bnAgent.delegate = self;
    [bnAgent getNews:req requestTime:0];
}
@end
