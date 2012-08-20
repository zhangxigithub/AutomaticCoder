//
//  AppDelegate.m
//  AutomaticCoder
//
//  Created by 张 玺 on 12-8-20.
//  Copyright (c) 2012年 me.zhangxi. All rights reserved.
//

#import "AppDelegate.h"
#import "JsonObject.h"


@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
    
//    JsonObject *obj = [[JsonObject alloc] init];
//    
//    obj.name = @"张玺";
//    obj.age = @5;
//    obj.male = YES;
//    obj.email = @"zzz";
//    NSLog(@"%@",obj);
//    
//    NSDictionary *dic = @{ @"root" : obj };
//    
//    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//
//    NSData * myData = [NSKeyedArchiver archivedDataWithRootObject:dic];
//    BOOL result = [myData writeToFile:[NSString stringWithFormat:@"%@/ddd",docDir] atomically:NO];
//    
//    NSData * ddd = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/ddd",docDir]];
//    NSDictionary * myDict = [NSKeyedUnarchiver unarchiveObjectWithData:ddd];
//    JsonObject *bb = [myDict objectForKey:@"root"];
//    NSLog(@"bb.name:%@",bb.name);
    
}

- (IBAction)json:(id)sender {

    json = [[JSONWindowController alloc] initWithWindowNibName:@"JSONWindowController"];
    [[json window] makeKeyAndOrderFront:nil];
}
@end
