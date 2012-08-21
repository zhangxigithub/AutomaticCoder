//
//  JSONWindowController.h
//  AutomaticCoder
//
//  Created by 张 玺 on 12-8-20.
//  Copyright (c) 2012年 me.zhangxi. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JSONKit.h"

typedef enum
{
    kString = 0,
    kNumber = 1,
    kArray  = 2,
    kDictionary = 3,
    kBool   = 4,
}JsonValueType;


@interface JSONWindowController : NSWindowController

@property (unsafe_unretained) IBOutlet NSTextView *jsonContent;
@property (weak) IBOutlet NSTextField *jsonName;
@property (weak) IBOutlet NSTextField *preName;
@property (weak) IBOutlet NSTextField *jsonURL;

- (IBAction)useTextURL:(id)sender;


- (IBAction)getJSONWithURL:(id)sender;

- (IBAction)generateClass:(id)sender;

@end
