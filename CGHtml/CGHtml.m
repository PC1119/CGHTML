//
//  CGHtml.m
//  CGHtml
//
//  Created by qianfeng on 15/10/28.
//  Copyright © 2015年 qianfeng. All rights reserved.
//

#import "CGHtml.h"
@interface CGHtml ()
@property (nonatomic ,strong)NSMutableArray *searchArr;
@property (nonatomic ,strong)NSString *searchStr;
@end
@implementation CGHtml
{
    NSArray *diguiArr;
    NSMutableArray *diguiResult;
}
+(CGHtml*)manger
{
    static CGHtml *man = nil;
    static dispatch_once_t oncetoken;
    dispatch_once(&oncetoken, ^{
        man = [[CGHtml alloc] init];
    });
    return man;
}
-(NSString*)searchFirstTag:(NSString *)str
{
    return [self searchFirstTag:str fromStr:self.rootStr];
}
-(NSString *)searchFirstTag:(NSString *)str fromStr:(NSString *)rootStr
{
    _searchStr = nil;
    int a=0;
    NSRange range1;
    NSRange range2;
    NSRange range3;
    NSString *tagStr1 = [NSString stringWithFormat:@"<%@",str];
    NSString *tagStr2 = [NSString stringWithFormat:@"</%@>",str];
    NSString *middleStr = rootStr;
    
    range1 = [rootStr rangeOfString:tagStr1];
    if (range1.location == NSNotFound) {
        //        NSLog(@"Search Over");
    }else
    {
        middleStr = [rootStr substringFromIndex:range1.location + range1.length];
        do{
            range2 = [middleStr rangeOfString:tagStr1];
            range3 = [middleStr rangeOfString:tagStr2];
            if (range2.location != NSNotFound && range3.location != NSNotFound && range3.location > range2.location) {
                a++;
                middleStr = [middleStr substringFromIndex:range2.location + range2.length];
                range1.length += range2.location + range2.length;
            }else if (range2.location != NSNotFound && range3.location != NSNotFound && range3.location < range2.location)
            {
                a--;
                middleStr = [middleStr substringFromIndex:range3.location + range3.length];
                range1.length += range3.location + range3.length;
            }else if (range2.location == NSNotFound && range3.location != NSNotFound)
            {
                a--;
                middleStr = [middleStr substringFromIndex:range3.location + range3.length];
                range1.length += range3.location + range3.length;
            }else if(range3.location == NSNotFound)
            {
                NSLog(@"The html is error;");
                break;
            }
        }while(a >= 0);
        _searchStr = [rootStr substringWithRange:NSMakeRange(range1.location, range1.length)];
    }
    return _searchStr;
}
-(NSArray *)searchAllTag:(NSString *)str
{
    return [self searchAllTag:str fromStr:self.rootStr];
}
-(NSArray *)searchAllTag:(NSString *)str fromStr:(NSString *)rootStr
{
    _searchArr = [NSMutableArray array];
    NSString *middleStr = rootStr;
    NSRange range;
    do{
        NSString *searchStr = [self searchFirstTag:str fromStr:middleStr];
        if (searchStr) {
            [_searchArr addObject:searchStr];
            range = [middleStr rangeOfString:searchStr];
            middleStr = [middleStr substringFromIndex:range.location + range.length];
        }else
        {
            break;
        }
    }while(1);
    return _searchArr;
}
-(NSArray *)searchTagWithPath:(NSString *)str
{
    return [self searchTagWithPath:str andFromStr:self.rootStr];
}
-(NSArray *)searchTagWithPath:(NSString *)str andFromStr:(NSString *)fromStr
{
    NSArray *searchArr = nil;
    diguiArr = nil;
    diguiArr = [str componentsSeparatedByString:@"/"];
    diguiResult = [NSMutableArray array];
    searchArr = [self diguiFromStr:fromStr andStrNum:0];
    return searchArr;
}
-(NSArray *)diguiFromStr:(NSString *)fromStr andStrNum:(NSInteger)num
{
    NSArray *arr = nil;
    arr = [self searchAllTag:diguiArr[num++] fromStr:fromStr];
    if (arr) {
        if (num == diguiArr.count) {
            [diguiResult addObjectsFromArray:arr];
        }else
        {
            for (NSString *str in arr) {
                [self diguiFromStr:str andStrNum:num];
            }
        }
    }else
    {
        return nil;
    }
    return diguiResult;
}
-(NSString *)valueFromTag:(NSString *)str
{
    NSString *valueStr = nil;
    NSString *middleStr = nil;
    NSRange range2;
    NSRange range1 = [str rangeOfString:@">"];
    if (range1.location != NSNotFound) {
        middleStr = [str substringFromIndex:range1.location+1];
        range2 = [middleStr rangeOfString:@"<"];
        if (range2.location != NSNotFound) {
            valueStr = [middleStr substringToIndex:range2.location];
        }
    }
    return valueStr;
}
-(NSString *)valueOrTagFromTag:(NSString *)str
{
    NSString *valueStr = nil;
    NSMutableString *middleStr = [NSMutableString string];
    for (NSInteger i = [str length] - 1; i > 0 ; i -- ) {
        char c = [str characterAtIndex:i];
        [middleStr appendFormat:@"%c",c];
    }
    NSRange range2 = [middleStr rangeOfString:@"<"];
    NSRange range1 = [str rangeOfString:@">"];
    if (range1.location != NSNotFound || range2.location != NSNotFound) {
        valueStr = [str substringWithRange:NSMakeRange(range1.location + 1, [str length]- range1.location - range2.location -2)];
    }
    return valueStr;
}
-(NSString *)attribeteValueFromTag:(NSString *)str andAttribe:(NSString *)attribete
{
    NSRange range1 = [str rangeOfString:attribete];
    if (range1.location != NSNotFound) {
        NSString *middleStr = [str substringFromIndex:range1.location];
        NSArray *arr = [middleStr componentsSeparatedByString:@"\""];
        if (arr.count > 2) {
            return arr[1];
        }
    }
    return nil;
}
-(NSInteger)searchNumberWithStr:(NSString *)str andFromStr:(NSString *)fromStr
{
    NSArray *arr = [fromStr componentsSeparatedByString:str];
    return arr.count - 1 ;
}
@end
