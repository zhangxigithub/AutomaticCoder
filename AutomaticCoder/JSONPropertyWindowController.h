//
//  JSONPropertyWindowController.h
//  AutomaticCoder
//
//  Created by 张 玺 on 12-8-22.
//  Copyright (c) 2012年 me.zhangxi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface JSONPropertyWindowController : NSWindowController
{
    NSString *path;
}
@property (weak) IBOutlet NSTableView *table;
@property(nonatomic,strong)  NSArrayController *arrayController;

- (IBAction)closeWindow:(id)sender;



@end
