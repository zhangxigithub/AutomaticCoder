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
       self.zxage  = [json objectForKey:@"age"];
 self.zxemail  = [json objectForKey:@"email"];
 self.zxname  = [json objectForKey:@"name"];
 self.zxmale = [[json objectForKey:@"male"] booleanValue];
 
    }
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.zxage forKey:@"zx_age"];
[aCoder encodeObject:self.zxemail forKey:@"zx_email"];
[aCoder encodeObject:self.zxname forKey:@"zx_name"];
[aCoder encodeBool:self.zxmale forKey:@"zx_male"];

}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        self.zxage = [aDecoder decodeObjectForKey:@"zx_age"];
 self.zxemail = [aDecoder decodeObjectForKey:@"zx_email"];
 self.zxname = [aDecoder decodeObjectForKey:@"zx_name"];
 self.zxmale = [aDecoder decodeBoolForKey:@"zx_male"];

    }
    return self;
}



@end
