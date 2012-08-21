//
//  
//  AutomaticCoder
//
//  Created by 张玺自动代码生成器   http://zhangxi.me
//  Copyright (c) 2012年 me.zhangxi. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface JsonObject : NSObject<NSCoding>

@property (nonatomic,strong) NSNumber *zxage;
@property (nonatomic,strong) NSString *zxemail;
@property (nonatomic,strong) NSString *zxname;
@property (nonatomic,assign) BOOL zxmale;
 

-(void)config:(NSDictionary *)json;

@end
