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
}


-(void)generateClass:(NSString *)name forDic:(NSDictionary *)json
{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
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





- (IBAction)useTextURL:(id)sender {
    jsonURL.stringValue = @"http://zxapi.sinaapp.com";
}

- (IBAction)getJSONWithURL:(id)sender {
    NSURL *url = [NSURL URLWithString:jsonURL.stringValue];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                                        returningResponse:nil
                                                                    error:nil];
    NSDictionary *json = [data objectFromJSONData];
    
    jsonContent.string = [json JSONStringWithOptions:JKSerializeOptionPretty error:nil];
}




- (IBAction)generateClass:(id)sender {
    NSDictionary *json   = [jsonContent.string objectFromJSONString];
    
    if(json == nil)
    {
        jsonContent.string = @"介个...json格式不对吧。。。。。";
        return;
    }
    
    [self generateClass:jsonName.stringValue forDic:json];
    
    jsonContent.string = @"生成了.h.m(ARC)文件，给您放桌面上了，看看格式对不对。";     
}


//表示该数组内有且只有字典 并且 结构一致。
-(BOOL)isDataArray:(NSArray *)array
{
    if(array.count <=0 ) return NO;
    for(id item in array)
    {
        if([self type:item] != kDictionary)
        {
            return NO;
        }
    }
    
    NSMutableSet *keys = [NSMutableSet set];
    for(NSString *key in [[array objectAtIndex:0] allKeys])
    {
        [keys addObject:key];
    }
    
    
    for(id item in array)
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















