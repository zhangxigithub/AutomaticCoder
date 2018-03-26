//
//  AutoControlCodeWindowController.h
//  AutomaticCoder
//
//  Created by zhanyun on 17/8/1.
//  Copyright © 2017年 me.zhangxi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AutoControlCodeWindowController : NSWindowController

@property (unsafe_unretained) IBOutlet NSTextView *codeTextView;
@property (weak) IBOutlet NSTextField *classNameTextField;


@end
