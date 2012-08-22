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
    //NSTableColumn *jsonKey = [table tableColumnWithIdentifier:@"jsonKey"];
    
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
    
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
