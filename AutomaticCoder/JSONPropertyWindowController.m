//
//  JSONPropertyWindowController.m
//  AutomaticCoder
//
//  Created by 张 玺 on 12-8-22.
//  Copyright (c) 2012年 me.zhangxi. All rights reserved.
//

#import "JSONPropertyWindowController.h"

@interface JSONPropertyWindowController ()

@end

@implementation JSONPropertyWindowController
@synthesize table;


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
    
    NSTableColumn *jsonKey = [table tableColumnWithIdentifier:@"jsonKey"];
    NSTableColumn *jsonType = [table tableColumnWithIdentifier:@"jsonType"];
    NSTableColumn *classKey = [table tableColumnWithIdentifier:@"classKey"];
    NSTableColumn *classType = [table tableColumnWithIdentifier:@"classType"];
    NSTableColumn *className = [table tableColumnWithIdentifier:@"className"];
    
    [jsonKey bind:NSValueBinding
     toObject:self.arrayController
  withKeyPath:@"arrangedObjects.jsonKey"
      options:nil];
    [jsonType bind:NSValueBinding
         toObject:self.arrayController
      withKeyPath:@"arrangedObjects.jsonType"
          options:nil];
    [classKey bind:NSValueBinding
         toObject:self.arrayController
      withKeyPath:@"arrangedObjects.classKey"
          options:nil];
    [classType bind:NSValueBinding
         toObject:self.arrayController
      withKeyPath:@"arrangedObjects.classType"
          options:nil];
    [className bind:NSValueBinding
           toObject:self.arrayController
        withKeyPath:@"arrangedObjects.className"
            options:nil];
    
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}
/*
-(void)generateClass:(NSString *)name forDic:(NSDictionary *)json
{
    //准备模板
    NSMutableString *templateH =[[NSMutableString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"json" ofType:@"zx1"]
                                                                       encoding:NSUTF8StringEncoding
                                                                          error:nil];
    NSMutableString *templateM =[[NSMutableString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"json" ofType:@"zx2"]
                                                                       encoding:NSUTF8StringEncoding
                                                                          error:nil];
    
    
    //.h
    //name
    //property
    NSMutableString *proterty = [NSMutableString string];
    NSMutableString *import = [NSMutableString string];
    
    for(NSString *key in [json allKeys])
    {
        JsonValueType type = [self type:[json objectForKey:key]];
        switch (type) {
            case kString:
            case kNumber:
                [proterty appendFormat:@"@property (nonatomic,strong) %@ *%@%@;\n",[self typeName:type],preName.stringValue,key];
                break;
            case kArray:
            {
                if([self isDataArray:[json objectForKey:key]])
                {
                    [proterty appendFormat:@"@property (nonatomic,strong) NSMutableArray *%@%@;\n",preName.stringValue,key];
                    [import appendFormat:@"#import \"%@Entity.h\"",key];
                    [self generateClass:[NSString stringWithFormat:@"%@Entity",key] forDic:[[json objectForKey:key]objectAtIndex:0]];
                }
            }
                break;
            case kDictionary:
                [proterty appendFormat:@"@property (nonatomic,strong) %@Entity *%@%@;\n",key,preName.stringValue,key];
                [import appendFormat:@"#import \"%@Entity.h\"",key];
                [self generateClass:[NSString stringWithFormat:@"%@Entity",key] forDic:[json objectForKey:key]];
                
                break;
            case kBool:
                [proterty appendFormat:@"@property (nonatomic,assign) %@ %@%@;\n",[self typeName:type],preName.stringValue,key];
                break;
            default:
                break;
        }
    }
    
    [templateH replaceOccurrencesOfString:@"#name#"
                               withString:name
                                  options:NSCaseInsensitiveSearch
                                    range:NSMakeRange(0, templateH.length)];
    [templateH replaceOccurrencesOfString:@"#import#"
                               withString:import
                                  options:NSCaseInsensitiveSearch
                                    range:NSMakeRange(0, templateH.length)];
    [templateH replaceOccurrencesOfString:@"#property#"
                               withString:proterty
                                  options:NSCaseInsensitiveSearch
                                    range:NSMakeRange(0, templateH.length)];
    
    //.m
    //NSCoding
    //name
    [templateM replaceOccurrencesOfString:@"#name#"
                               withString:name
                                  options:NSCaseInsensitiveSearch
                                    range:NSMakeRange(0, templateM.length)];
    
    
    NSMutableString *config = [NSMutableString string];
    NSMutableString *encode = [NSMutableString string];
    NSMutableString *decode = [NSMutableString string];
    
    NSDictionary *list =  @{
    @"config":config,
    @"encode":encode,
    @"decode":decode
    };
    
    
    for(NSString *key in [json allKeys])
    {
        JsonValueType type = [self type:[json objectForKey:key]];
        switch (type) {
            case kString:
            case kNumber:
                [config appendFormat:@"self.%@%@  = [json objectForKey:@\"%@\"];\n ",preName.stringValue,key,key];
                [encode appendFormat:@"[aCoder encodeObject:self.%@%@ forKey:@\"zx_%@\"];\n",preName.stringValue,key,key];
                [decode appendFormat:@"self.%@%@ = [aDecoder decodeObjectForKey:@\"zx_%@\"];\n ",preName.stringValue,key,key];
                break;
            case kArray:
            {
                if([self isDataArray:[json objectForKey:key]])
                {
                    [config appendFormat:@"self.%@%@ = [NSMutableArray array];\n",preName.stringValue,key];
                    [config appendFormat:@"for(NSDictionary *item in [json objectForKey:@\"%@\"])\n",key];
                    [config appendString:@"{\n"];
                    [config appendFormat:@"[self.%@%@ addObject:[[%@Entity alloc] initWithJson:item]];\n",preName.stringValue,key,key];
                    [config appendString:@"}\n"];
                    [encode appendFormat:@"[aCoder encodeObject:self.%@%@ forKey:@\"zx_%@\"];\n",preName.stringValue,key,key];
                    [decode appendFormat:@"self.%@%@ = [aDecoder decodeObjectForKey:@\"zx_%@\"];\n ",preName.stringValue,key,key];
                }
            }
                break;
            case kDictionary:
                [config appendFormat:@"self.%@%@  = [[%@Entity alloc] initWithJson:[json objectForKey:@\"%@\"]];\n ",preName.stringValue,key,key,key];
                [encode appendFormat:@"[aCoder encodeObject:self.%@%@ forKey:@\"zx_%@\"];\n",preName.stringValue,key,key];
                [decode appendFormat:@"self.%@%@ = [aDecoder decodeObjectForKey:@\"zx_%@\"];\n ",preName.stringValue,key,key];
                
                break;
            case kBool:
                [config appendFormat:@"self.%@%@ = [[json objectForKey:@\"%@\"]boolValue];\n ",preName.stringValue,key,key];
                [encode appendFormat:@"[aCoder encodeBool:self.%@%@ forKey:@\"zx_%@\"];\n",preName.stringValue,key,key];
                [decode appendFormat:@"self.%@%@ = [aDecoder decodeBoolForKey:@\"zx_%@\"];\n",preName.stringValue,key,key];
                break;
            default:
                break;
        }
    }
    
    //修改模板
    for(NSString *key in [list allKeys])
    {
        [templateM replaceOccurrencesOfString:[NSString stringWithFormat:@"#%@#",key]
                                   withString:[list objectForKey:key]
                                      options:NSCaseInsensitiveSearch
                                        range:NSMakeRange(0, templateM.length)];
    }
    
    
    //写文件
    NSLog(@"%@",[NSString stringWithFormat:@"%@/%@.h",path,name]);
    [templateH writeToFile:[NSString stringWithFormat:@"%@/%@.h",path,name]
                atomically:NO
                  encoding:NSUTF8StringEncoding
                     error:nil];
    [templateM writeToFile:[NSString stringWithFormat:@"%@/%@.m",path,name]
                atomically:NO
                  encoding:NSUTF8StringEncoding
                     error:nil];
    
    
}
*/
- (IBAction)closeWindow:(id)sender {
    [self.window close];
}
@end
