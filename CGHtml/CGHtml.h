//
//  CGHtml.h
//  CGHtml
// 123
//  Created by caogen on 15/10/28.
//  Copyright © 2015年 caogen. All rights reserved.

#import <Foundation/Foundation.h>

@interface CGHtml : NSObject
@property (nonatomic ,strong)NSString *rootStr;

+(CGHtml*)manger;
-(NSString *)searchFirstTag:(NSString *)str;
-(NSString *)searchFirstTag:(NSString *)str fromStr:(NSString *)rootStr;
-(NSArray *)searchAllTag:(NSString *)str;
-(NSArray *)searchAllTag:(NSString *)str fromStr:(NSString *)rootStr;
-(NSInteger)searchNumberWithStr:(NSString *)str andFromStr:(NSString *)fromStr;
-(NSArray *)searchTagWithPath:(NSString *)str;
-(NSArray *)searchTagWithPath:(NSString *)str andFromStr:(NSString *)fromStr;
-(NSString *)valueFromTag:(NSString *)str;
-(NSString *)valueOrTagFromTag:(NSString *)str;
-(NSString *)attribeteValueFromTag:(NSString *)str andAttribe:(NSString *)attribete;
@end
