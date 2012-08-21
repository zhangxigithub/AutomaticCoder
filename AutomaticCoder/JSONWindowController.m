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
@synthesize preName;

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
}



- (IBAction)generateClass:(id)sender {
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *name       = jsonName.stringValue;
    NSDictionary *json   = [jsonContent.string objectFromJSONString];
    
    if(json == nil)
    {
        jsonContent.string = @"json格式不对吧。。。。。";
        return;
    }
    
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
   
    for(NSString *key in [json allKeys])
    {
        JsonValueType type = [self type:[json objectForKey:key]];
        switch (type) {
            case 0:
            case 1:
                [proterty appendFormat:@"@property (nonatomic,strong) %@ *%@%@;\n",[self typeName:type],preName.stringValue,key];
                break;
            case 2:
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
            case 0:
            case 1:
                [config appendFormat:@"self.%@%@  = [json objectForKey:@\"%@\"];\n ",preName.stringValue,key,key];
                [encode appendFormat:@"[aCoder encodeObject:self.%@%@ forKey:@\"zx_%@\"];\n",preName.stringValue,key,key];
                [decode appendFormat:@"self.%@%@ = [aDecoder decodeObjectForKey:@\"zx_%@\"];\n ",preName.stringValue,key,key];
                break;
            case 2:
                [config appendFormat:@"self.%@%@ = [[json objectForKey:@\"%@\"] booleanValue];\n ",preName.stringValue,key,key];
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
    [templateH writeToFile:[NSString stringWithFormat:@"%@/%@.h",docDir,name]
                atomically:NO
                  encoding:NSUTF8StringEncoding
                     error:nil];
    [templateM writeToFile:[NSString stringWithFormat:@"%@/%@.m",docDir,name]
                atomically:NO
                  encoding:NSUTF8StringEncoding
                     error:nil];
    
    jsonContent.string = @"生成了.h.m(ARC)文件，给您放桌面上了，看看格式对不对。哦，对了，目前还不支持json里面嵌套数组和字典，以后可能会加上。"; 
}

-(JsonValueType)type:(id)obj
{
    if([[obj className] isEqualToString:@"__NSCFString"]) return kString;
    else if([[obj className] isEqualToString:@"__NSCFNumber"]) return kNumber;
    else if([[obj className] isEqualToString:@"__NSCFBoolean"])return kBool;
    return -1;
}
-(NSString *)typeName:(JsonValueType)type
{
    switch (type) {
        case kString:
            return @"NSString";
            break;
        case kNumber:
            return @"NSNumber";
            break;
        case kBool:
            return @"BOOL";
            break;
            
        default:
            break;
    }
}

@end















