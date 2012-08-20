//
//  
//  AutomaticCoder
//
//  Created by 张玺自动代码生成器   http://zhangxi.me
//  Copyright (c) 2012年 me.zhangxi. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface JsonObject : NSObject<NSCoding>

@property(nonatomic,strong) NSNumber *age;
@property(nonatomic,strong) NSString *email;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,assign) BOOL male;
 

-(void)config:(NSDictionary *)json;

@end
