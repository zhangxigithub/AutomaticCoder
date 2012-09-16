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
@synthesize jsonURL;

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
    array = [[NSArrayController alloc] init];
}


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
                    [import appendFormat:@"#import \"%@Entity.h\"",[self uppercaseFirstChar:key]];
                    [self generateClass:[NSString stringWithFormat:@"%@Entity",[self uppercaseFirstChar:key]] forDic:[[json objectForKey:key]objectAtIndex:0]];
                }
            }
                break;
            case kDictionary:
                [proterty appendFormat:@"@property (nonatomic,strong) %@Entity *%@%@;\n",[self uppercaseFirstChar:key],preName.stringValue,key];
                [import appendFormat:@"#import \"%@Entity.h\"",[self uppercaseFirstChar:key]];
                [self generateClass:[NSString stringWithFormat:@"%@Entity",[self uppercaseFirstChar:key]] forDic:[json objectForKey:key]];
                
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
    NSMutableString *description = [NSMutableString string];
    
    NSDictionary *list =  @{
    @"config":config,
    @"encode":encode,
    @"decode":decode,
    @"description":description
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
                [description appendFormat:@"result = [result stringByAppendingFormat:@\"%@%@ : %%@\\n\",self.%@%@];\n",preName.stringValue,key,preName.stringValue,key];
                break;
            case kArray:
            {
                if([self isDataArray:[json objectForKey:key]])
                {
                    [config appendFormat:@"self.%@%@ = [NSMutableArray array];\n",preName.stringValue,key];
                    [config appendFormat:@"for(NSDictionary *item in [json objectForKey:@\"%@\"])\n",key];
                    [config appendString:@"{\n"];
                    [config appendFormat:@"[self.%@%@ addObject:[[%@Entity alloc] initWithJson:item]];\n",preName.stringValue,key,[self uppercaseFirstChar:key]];
                    [config appendString:@"}\n"];
                    [encode appendFormat:@"[aCoder encodeObject:self.%@%@ forKey:@\"zx_%@\"];\n",preName.stringValue,key,key];
                    [decode appendFormat:@"self.%@%@ = [aDecoder decodeObjectForKey:@\"zx_%@\"];\n ",preName.stringValue,key,key];
                   [description appendFormat:@"result = [result stringByAppendingFormat:@\"%@%@ : %%@\\n\",self.%@%@];\n",preName.stringValue,key,preName.stringValue,key]; 
                }
            }
                break;
            case kDictionary:
                [config appendFormat:@"self.%@%@  = [[%@Entity alloc] initWithJson:[json objectForKey:@\"%@\"]];\n ",preName.stringValue,key,[self uppercaseFirstChar:key],key];
                [encode appendFormat:@"[aCoder encodeObject:self.%@%@ forKey:@\"zx_%@\"];\n",preName.stringValue,key,key];
                [decode appendFormat:@"self.%@%@ = [aDecoder decodeObjectForKey:@\"zx_%@\"];\n ",preName.stringValue,key,key];
                [description appendFormat:@"result = [result stringByAppendingFormat:@\"%@%@ : %%@\\n\",self.%@%@];\n",preName.stringValue,key,preName.stringValue,key]; 
                
                break;
            case kBool:
                [config appendFormat:@"self.%@%@ = [[json objectForKey:@\"%@\"]boolValue];\n ",preName.stringValue,key,key];
                [encode appendFormat:@"[aCoder encodeBool:self.%@%@ forKey:@\"zx_%@\"];\n",preName.stringValue,key,key];
                [decode appendFormat:@"self.%@%@ = [aDecoder decodeBoolForKey:@\"zx_%@\"];\n",preName.stringValue,key,key];
                [description appendFormat:@"result = [result stringByAppendingFormat:@\"%@%@ : %%@\\n\",self.%@%@?@\"yes\":@\"no\"];\n",preName.stringValue,key,preName.stringValue,key];
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



- (IBAction)useTestURL:(id)sender {
    jsonURL.stringValue = @"http://zxapi.sinaapp.com";
}

- (IBAction)getJSONWithURL:(id)sender {
    
    NSString *str = [jsonURL.stringValue stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                                        returningResponse:nil
                                                                    error:nil];
    
    NSDictionary *json = [data objectFromJSONData];
    if(json != nil)
    jsonContent.string = [json JSONStringWithOptions:JKSerializeOptionPretty error:nil];
}

-(void)generateProperty:(NSDictionary *)json withName:(NSString *)className;
{
    for(NSString *key in [json allKeys])
    {
        JsonValueType type = [self type:[json objectForKey:key]];
        switch (type) {
            case kString:
            {
                NSDictionary *dic =
                @{
                @"jsonKey":key,
                @"jsonType":@"string",
                @"classKey":[NSString stringWithFormat:@"%@%@",preName.stringValue,key],
                @"classType":@"NSString",
                @"className":className
                };
                [array addObject:[dic mutableCopy]];
            }
                break;
            case kNumber:
            {
                NSDictionary *dic =
                @{
                @"jsonKey":key,
                @"jsonType":@"number",
                @"classKey":[NSString stringWithFormat:@"%@%@",preName.stringValue,key],
                @"classType":@"NSNumber",
                @"className":className

                };
                [array addObject:[dic mutableCopy]];
            }
                break;
            case kArray:
            {
                {
                    NSDictionary *dic =
                    @{
                    @"jsonKey":key,
                    @"jsonType":@"array",
                    @"classKey":[NSString stringWithFormat:@"%@%@",preName.stringValue,key],
                    @"classType":[NSString stringWithFormat:@"NSArray(%@)",[self uppercaseFirstChar:key]],
                    @"className":className
                    };
                    [array addObject:[dic mutableCopy]];
                    if([self isDataArray:[json objectForKey:key]])
                    {
                        [self generateProperty:[[json objectForKey:key] objectAtIndex:0]
                                      withName:[self uppercaseFirstChar:key]];
                    }
                }
                break;
            }
                break;
            case kDictionary:
            {
                NSDictionary *dic =
                @{
                @"jsonKey":[self lowercaseFirstChar:key],
                @"jsonType":@"object",
                @"classKey":[NSString stringWithFormat:@"%@%@",preName.stringValue,key],
                @"classType":[self uppercaseFirstChar:key],
                @"className":className
                };
                [array addObject:[dic mutableCopy]];
                [self generateProperty:[json objectForKey:key]
                              withName:[self uppercaseFirstChar:key]];
            }
                break;
            case kBool:
            {
                NSDictionary *dic =
                @{
                @"jsonKey":[self lowercaseFirstChar:key],
                @"jsonType":@"bool",
                @"classKey":[NSString stringWithFormat:@"%@%@",preName.stringValue,key],
                @"classType":@"BOOL",
                @"className":className
                };
                [array addObject:[dic mutableCopy]];
            }
                break;
            default:
                break;
        }
    }
}

-(NSString *)uppercaseFirstChar:(NSString *)str
{
    return [NSString stringWithFormat:@"%@%@",[[str substringToIndex:1] uppercaseString],[str substringWithRange:NSMakeRange(1, str.length-1)]];
}
-(NSString *)lowercaseFirstChar:(NSString *)str
{
        return [NSString stringWithFormat:@"%@%@",[[str substringToIndex:1] lowercaseString],[str substringWithRange:NSMakeRange(1, str.length-1)]];
}

-(void)showPropertys:(NSDictionary *)json
{
    array = nil;
    array = [[NSArrayController alloc] init];
    
    [self generateProperty:json withName:jsonName.stringValue];
    
    
   propertyWindowController = [[JSONPropertyWindowController alloc] initWithWindowNibName:@"JSONPropertyWindowController"];
    propertyWindowController.arrayController = array;
    [propertyWindowController.window makeKeyAndOrderFront:nil];
    
}



- (IBAction)generateClass:(id)sender {
    
    
    
    NSDictionary *json   = [jsonContent.string objectFromJSONString];
    
    if(json == nil)
    {
        jsonContent.string = @"json is invalid.";
        return;
    }

    
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    panel.canChooseDirectories = YES;
    panel.canChooseFiles = NO;
    [panel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
        
        if(result == 0) return ;
        
        path = [panel.URL path];
        [self generateClass:jsonName.stringValue forDic:json];
        jsonContent.string = @"generate .h.m(ARC)files，put those to the folder";
    
    }];

    
}

- (IBAction)checkProperty:(id)sender {
    
    NSDictionary *json   = [jsonContent.string objectFromJSONString];
    
    if(json == nil)
    {
        jsonContent.string = @"json is invalid.";
        return;
    }
    
    [self showPropertys:json];
}


//表示该数组内有且只有字典 并且 结构一致。
-(BOOL)isDataArray:(NSArray *)theArray
{
    if(theArray.count <=0 ) return NO;
    for(id item in theArray)
    {
        if([self type:item] != kDictionary)
        {
            return NO;
        }
    }
    
    NSMutableSet *keys = [NSMutableSet set];
    for(NSString *key in [[theArray objectAtIndex:0] allKeys])
    {
        [keys addObject:key];
    }
    
    
    for(id item in theArray)
    {
        NSMutableSet *newKeys = [NSMutableSet set];
        for(NSString *key in [item allKeys])
        {
            [newKeys addObject:key];
        }
        
        if([keys isEqualToSet:newKeys] == NO)
        {
            return NO;
        }
    }
    return YES;
}


-(JsonValueType)type:(id)obj
{
    if([[obj className] isEqualToString:@"__NSCFString"] || [[obj className] isEqualToString:@"__NSCFConstantString"]) return kString;
    else if([[obj className] isEqualToString:@"__NSCFNumber"]) return kNumber;
    else if([[obj className] isEqualToString:@"__NSCFBoolean"])return kBool;
    else if([[obj className] isEqualToString:@"JKDictionary"])return kDictionary;
    else if([[obj className] isEqualToString:@"JKArray"])return kArray;
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
        case kArray:
        case kDictionary:
            return @"";
            break;
            
        default:
            break;
    }
}

@end















