//
//  JSONWindowController.m
//  AutomaticCoder
//
//  Created by 张 玺 on 12-8-20.
//  Copyright (c) 2012年 me.zhangxi. All rights reserved.
//

#import "JSONWindowController.h"

@interface JSONWindowController ()

@end

@implementation JSONWindowController
@synthesize jsonContent;
@synthesize jsonName;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction)generateClass:(id)sender {
    //NSString *headerFile = [NSString string];
    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *name       = jsonName.stringValue;
    NSDictionary *json   = [jsonContent.string objectFromJSONString];
    
    
    
    if(json == nil)
    {
        jsonContent.string = @"json格式不对吧。。。。。";
        return;
    }
    
    NSMutableString *templateH =[[NSMutableString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"json" ofType:@"zx1"]
                                                                       encoding:NSUTF8StringEncoding
                                                                          error:nil];
    NSMutableString *templateM =[[NSMutableString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"json" ofType:@"zx2"]
                                                                       encoding:NSUTF8StringEncoding
                                                                          error:nil];


    //.h
    //name
    [templateH replaceOccurrencesOfString:@"#name#"
                               withString:name
                                  options:NSCaseInsensitiveSearch
                                    range:NSMakeRange(0, templateH.length)];
    
    
    //property
    NSMutableString *proterty = [NSMutableString string];
    for(NSString *key in [json allKeys])
    {
        NSLog(@"%@:%@",key,[[json objectForKey:key] className]);
        if([self isNSString:[json objectForKey:key]])
            [proterty appendFormat:@"@property(nonatomic,strong) NSString *%@;\n",key];
        
        else if([self isNSNumber:[json objectForKey:key]])
            [proterty appendFormat:@"@property(nonatomic,strong) NSNumber *%@;\n",key];
        
        else if([self isBoolen:[json objectForKey:key]])
            [proterty appendFormat:@"@property(nonatomic,assign) BOOL %@;\n",key];
        
        //else if([self isNSArray:[json objectForKey:key]])
        //    [proterty appendFormat:@"@property(nonatomic,strong) NSArray *%@;\n",key];
        
        //else if([self isNSDictionary:[json objectForKey:key]])
        //    [proterty appendFormat:@"@property(nonatomic,strong) NSDictionary *%@;\n",key];
  
    }
    [templateH replaceOccurrencesOfString:@"#property#"
                               withString:proterty
                                  options:NSCaseInsensitiveSearch
                                    range:NSMakeRange(0, templateH.length)];
    
    
    
    NSError *error;
    
    [templateH writeToFile:[NSString stringWithFormat:@"%@/%@.h",docDir,name]
                atomically:NO
                  encoding:NSUTF8StringEncoding
                     error:&error];
    if(error != nil)
        NSLog(@"%@",error);
    
    //.m
    //NSCoding
    //name
    [templateM replaceOccurrencesOfString:@"#name#"
                               withString:name
                                  options:NSCaseInsensitiveSearch
                                    range:NSMakeRange(0, templateM.length)];
    
    //config
    NSMutableString *config = [NSMutableString string];
    for(NSString *key in [json allKeys])
    {
        if([self isNSString:[json objectForKey:key]] ||
           [self isNSNumber:[json objectForKey:key]])
            [config appendFormat:@"self.%@  = [json objectForKey:@\"%@\"];\n ",key,key];
        else if([self isBoolen:[json objectForKey:key]])
            [config appendFormat:@"self.%@ = [[json objectForKey:@\"%@\"] booleanValue];\n ",key,key];
    }
    [templateM replaceOccurrencesOfString:@"#config#"
                               withString:config
                                  options:NSCaseInsensitiveSearch
                                    range:NSMakeRange(0, templateM.length)];
    
    
    
    //encode
    NSMutableString *encode = [NSMutableString string];
    for(NSString *key in [json allKeys])
    {
        if([self isNSString:[json objectForKey:key]] || [self isNSNumber:[json objectForKey:key]])
            [encode appendFormat:@"[aCoder encodeObject:self.%@ forKey:@\"zx_%@\"];\n",key,key];
        else if([self isBoolen:[json objectForKey:key]])
            [encode appendFormat:@"[aCoder encodeBool:self.%@ forKey:@\"zx_%@\"];\n",key,key];
    }
    [templateM replaceOccurrencesOfString:@"#encode#"
                               withString:encode
                                  options:NSCaseInsensitiveSearch
                                    range:NSMakeRange(0, templateM.length)];
    
    
    //decode
    NSMutableString *decode = [NSMutableString string];
    for(NSString *key in [json allKeys])
    {
        if([self isNSString:[json objectForKey:key]] || [self isNSNumber:[json objectForKey:key]])
            [decode appendFormat:@"self.%@ = [aDecoder decodeObjectForKey:@\"zx_%@\"];\n ",key,key];
        else if([self isBoolen:[json objectForKey:key]])
            [decode appendFormat:@"self.%@ = [aDecoder decodeBoolForKey:@\"zx_%@\"];\n",key,key];
    }
    [templateM replaceOccurrencesOfString:@"#decode#"
                               withString:decode
                                  options:NSCaseInsensitiveSearch
                                    range:NSMakeRange(0, templateM.length)];
    

    //NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    [templateM writeToFile:[NSString stringWithFormat:@"%@/%@.m",docDir,name]
                atomically:NO
                  encoding:NSUTF8StringEncoding
                     error:&error];
    if(error != nil)
        NSLog(@"%@",error);
    
    
    
    if(error == nil)
    {
        jsonContent.string = @"生成了.h.m(ARC)文件，给您放桌面上了，看看格式对不对。哦，对了，目前还不支持json里面嵌套数组和字典，以后可能会加上。";
    }
    //jsonContent.string = templateM;
    //.h
    //[[NSWorkspace sharedWorkspace] selectFile:nil inFileViewerRootedAtPath:@"~/Desktop"];
    //[[NSWorkspace sharedWorkspace]];
    
}


-(BOOL)isNSString:(id)obj
{
    if([[obj className] isEqualToString:@"__NSCFString"])
        return YES;
    else
        return NO;
}

-(BOOL)isNSNumber:(id)obj
{
    if([[obj className] isEqualToString:@"__NSCFNumber"])
        return YES;
    else
        return NO;
}

-(BOOL)isNSDictionary:(id)obj
{
    if([[obj className] isEqualToString:@"JKDictionary"])
        return YES;
    else
        return NO;
}

-(BOOL)isNSArray:(id)obj
{
    if([[obj className] isEqualToString:@"JKArray"])
        return YES;
    else
        return NO;
}

-(BOOL)isBoolen:(id)obj
{
    if([[obj className] isEqualToString:@"__NSCFBoolean"])
        return YES;
    else
        return NO;
}

@end















