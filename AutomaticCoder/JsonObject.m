//
//  
//  AutomaticCoder
//
//  Created by 张玺自动代码生成器  http://zhangxi.me
//  Copyright (c) 2012年 me.zhangxi. All rights reserved.
//
#import "JsonObject.h"

@implementation JsonObject


-(void)config:(NSDictionary *)json
{
    if(json != nil)
    {
       self.age  = [json objectForKey:@"age"];
 self.email  = [json objectForKey:@"email"];
 self.name  = [json objectForKey:@"name"];
 self.male = [[json objectForKey:@"male"] booleanValue];
 
    }
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.age forKey:@"zx_age"];
[aCoder encodeObject:self.email forKey:@"zx_email"];
[aCoder encodeObject:self.name forKey:@"zx_name"];
[aCoder encodeBool:self.male forKey:@"zx_male"];

}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        self.age = [aDecoder decodeObjectForKey:@"zx_age"];
 self.email = [aDecoder decodeObjectForKey:@"zx_email"];
 self.name = [aDecoder decodeObjectForKey:@"zx_name"];
 self.male = [aDecoder decodeBoolForKey:@"zx_male"];

    }
    return self;
}



@end
