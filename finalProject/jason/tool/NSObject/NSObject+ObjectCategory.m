//
//  NSObject+ObjectCategory.m
//  carpool
//
//  Created by lab406 on 2016/8/8.
//
//

#import "NSObject+ObjectCategory.h"
#import <objc/runtime.h>

@implementation NSObject (ObjectCategory)
#pragma mark - JSON parser
- (void)setValueByDic:(NSDictionary *)dic{
    
    for (NSString *key in dic)
    {
        if ([self respondsToSelector:NSSelectorFromString(key)])
        {
            if (![[dic valueForKey:key] isKindOfClass:[NSDictionary class]])
                [self setValue:[dic valueForKey:key] forKey:key];
        }
    }
}

- (void)parseJsonByDic:(NSDictionary *)dic{
    //get key for loop
    for (NSString *key in dic)
    {
        
        NSString *classKey = ([key isEqualToString:@"id"])? @"ID":key;
        
        //make sure this class have the key
        if ([self respondsToSelector:NSSelectorFromString(classKey)])
        {
            if ([[dic valueForKey:key]isKindOfClass:[NSDictionary class]])
            {
                //this value is dictionary
                //it means this key is custom class
                NSDictionary *secDic = [dic valueForKey:key];
                [self setClassValueByDic:secDic inKey:classKey];
            }
            else if ([[dic valueForKey:key]isKindOfClass:[NSArray class]])
            {
                //this value is array
                NSArray *theArr = [dic valueForKey:key];
                [self setValueByArray:theArr keyIs:classKey];
            }
            else
            {
                //just normal key
                [self setValue:[dic valueForKey:key] forKey:classKey];
            }
        }
    }
}

- (void)setClassValueByDic:(NSDictionary *)dic inKey:(NSString *)key{
    
    for (NSString *secKey in dic)
    {
        
        NSString *classKey = ([secKey isEqualToString:@"id"])? @"ID":secKey;
        
        //key path, e.g. self.bag.pen
        NSString *str = [NSString stringWithFormat:@"%@.%@",key,classKey];
        
        if ([[dic valueForKeyPath:secKey]isKindOfClass:[NSDictionary class]])
        {
            //this value is dictionary
            NSDictionary *secDic = [dic valueForKeyPath:secKey];
            [self setClassValueByDic:secDic inKey:str];
        }
        else if ([[dic valueForKeyPath:secKey]isKindOfClass:[NSArray class]])
        {
            //this value is array
            NSArray *theArr = [dic valueForKeyPath:secKey];
            [self setValueByArray:theArr keyIs:str];
        }
        else
        {
            //use key path to set value
            [self setValue:[dic valueForKey:secKey] forKeyPath:str];
        }
    }
}

- (void)setValueByArray:(NSArray *)arr keyIs:(NSString *)key{
    
    NSMutableArray *muArr = [[NSMutableArray alloc]init];
    NSArray *keyArr = [key componentsSeparatedByString:@"."];
    for (int i = 0; i < arr.count; i++)
    {
        if ([arr[i] isKindOfClass:[NSDictionary class]])
        {
            //this is a custom class contained by array
            //customClassInArray: is a override func in custom class
            //to tell me which class shuld I use
            
            NSObject *customObj = [self customClassInArray:keyArr.lastObject];
            [customObj parseJsonByDic:arr[i]];
            [muArr addObject:customObj];
        }
        else if ([arr[i] isKindOfClass:[NSArray class]])
        {
            //array in array, may I think too much?
            NSArray *descentArray = [self setDescentValueByArray:arr[i] keyIs:keyArr.lastObject];
            [muArr addObject:descentArray];
        }
        else
        {
            //this is just a normal array
            //e.g. @[@"a",@"b",@"c"]
            [muArr addObject:arr[i]];
        }
    }
    
    //set parsed array back
    [self setValue:muArr forKeyPath:key];
}

#pragma mark - override func for JSON parser
- (NSObject *)customClassInArray:(NSString *)arrayName{
    return [[NSObject alloc]init];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    NSLog(@"no %@ in %@",key , NSStringFromClass([self class]));
}

- (void)valueForUndefinedKey:(NSString *)key{
    NSLog(@"no %@ in %@",key , NSStringFromClass([self class]));
}

- (NSArray *)setDescentValueByArray:(NSArray *)arr keyIs:(NSString *)key{
    
    NSMutableArray *muArr = [[NSMutableArray alloc]init];
    NSString *newKey = [key stringByAppendingString:@"Descent"];
    for (int i = 0; i < arr.count; i++)
    {
        if ([arr[i] isKindOfClass:[NSDictionary class]])
        {
            /*like setValueByArray:keyIs:
             I think in the same array it will use the same class
             so I don't consider the situation that
             arr[0] is classA, but arr[1] is classB
             and even if I want to consider it, I don't know how to do*/
            
            NSObject *customObj = [self customClassInArray:newKey];
            [customObj parseJsonByDic:arr[i]];
            [muArr addObject:customObj];
        }
        else if ([arr[i] isKindOfClass:[NSArray class]])
        {
            NSArray *descentArray = [self setDescentValueByArray:arr[i] keyIs:newKey];
            [muArr addObject:descentArray];
        }
        else
        {
            //this is just a normal array
            //e.g. @[@"a",@"b",@"c"]
            [muArr addObject:arr[i]];
        }
    }
    
    return muArr;
}

@end
