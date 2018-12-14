//
//  NSObject+ObjectCategory.h
//  carpool
//
//  Created by lab406 on 2016/8/8.
//
//

#import <Foundation/Foundation.h>

@interface NSObject (ObjectCategory)
- (void)setValueByDic:(NSDictionary *)dic;
- (void)parseJsonByDic:(NSDictionary *)dic;

//- (UIViewController *)getViewController;
@end
