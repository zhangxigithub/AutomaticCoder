//
//  temp.m
//  AutomaticCoder
//
//  Created by 张 玺 on 12-8-20.
//  Copyright (c) 2012年 me.zhangxi. All rights reserved.
//

#import "temp.h"

@implementation temp

-(void)config:(NSDictionary *)json
{
    if(json != nil)
    {
        self.name  = [json objectForKey:@"name"];
        self.age   = [json objectForKey:@"age"];
        
    }
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"zx_name"];

}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        self.name = [aDecoder decodeObjectForKey:@"zx_name"];
        //[aDecoder decodeBoolForKey:@\"%zx_@\"];
    }
    return self;
}


@end
