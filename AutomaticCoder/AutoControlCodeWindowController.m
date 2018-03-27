//
//  AutoControlCodeWindowController.m
//  AutomaticCoder
//
//  Created by zhanyun on 17/8/1.
//  Copyright © 2017年 me.zhangxi. All rights reserved.
//

#import "AutoControlCodeWindowController.h"

@interface AutoControlCodeWindowController ()

@end

@implementation AutoControlCodeWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction)copyClick:(id)sender {
    NSPasteboard *pastBoard = [NSPasteboard generalPasteboard];
    [pastBoard declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:nil];
    [pastBoard setString:self.codeTextView.string forType:NSStringPboardType];
}


- (IBAction)addLabel:(id)sender {
    
    NSString *className = self.classNameTextField.stringValue.length>0?self.classNameTextField.stringValue:@"label";
    
    self.codeTextView.string = [NSString stringWithFormat:@"UILabel *%@ = [[UILabel alloc]init];\n%@.frame = CGRectMake(0,0,0,0);\n%@.text = @\"这是一串很长长长长长长长长长长长长长长长的测试文字，显示的完整吗\";\n%@.font = [UIFont systemFontOfSize:24];\n%@.textColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1];\n%@.backgroundColor = [UIColor lightGrayColor];\n%@.lineBreakMode = NSLineBreakByTruncatingHead;\n%@.numberOfLines = 0 ;\n%@.textAlignment = NSTextAlignmentCenter;\nCGSize titleSize = [%@.text boundingRectWithSize:CGSizeMake(60,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:24]} context:nil].size;\n%@.frame = CGRectMake(50, 50, titleSize.width, titleSize.height);\n[self.view addSubview:%@];",className,className,className,className,className,className,className,className,className,className,className,className] ;
    
}
- (IBAction)addButton:(id)sender {
    
    NSString *className = self.classNameTextField.stringValue.length>0?self.classNameTextField.stringValue:@"button";
    
    self.codeTextView.string = [NSString stringWithFormat:@"UIButton *%@ = [UIButton buttonWithType:UIButtonTypeCustom];\n%@.frame = CGRectMake(100, 300, 80, 44);\n[%@ setTitle:@\"OK\" forState:UIControlStateNormal];\n[%@ setTitle:@\"KO\" forState:UIControlStateHighlighted];\n%@.backgroundColor = [UIColor lightGrayColor];\n[self.view addSubview:%@];\n[%@ addTarget:self action:@selector(click%@:) forControlEvents:UIControlEventTouchUpInside];\n%@.tag = 111;",className,className,className,className,className,className,className,className,className];
    
}
- (IBAction)addTextField:(id)sender {
    NSString *className = self.classNameTextField.stringValue.length>0?self.classNameTextField.stringValue:@"textField";
    
    self.codeTextView.string = [NSString stringWithFormat:@"UITextField *%@ = [[UITextField alloc]init];\n%@.frame = CGRectMake(50, 0, 100, 35);\n%@.placeholder = @\"请输入\";\n%@.borderStyle = UITextBorderStyleRoundedRect;\n%@.clearButtonMode = UITextFieldViewModeWhileEditing;\n%@.keyboardType = UIKeyboardTypeDefault;\n[self.view addSubview:%@];",className,className,className,className,className,className,className];
}
- (IBAction)addImageView:(id)sender {
    NSString *className = self.classNameTextField.stringValue.length>0?self.classNameTextField.stringValue:@"imageView";
    
    self.codeTextView.string = [NSString stringWithFormat:@"UIImageView *%@ = [[UIImageView alloc]init];\n%@.frame = CGRectMake(0, 0, 100, 100);\n%@.image = [UIImage imageNamed:@\"bg.png\"];\n%@.contentMode = UIViewContentModeScaleToFill;\n[self.view addSubview:%@];",className,className,className,className,className];
}
- (IBAction)addSegment:(id)sender {
    NSString *className = self.classNameTextField.stringValue.length>0?self.classNameTextField.stringValue:@"segment";
    
    self.codeTextView.string = [NSString stringWithFormat:@"UISegmentedControl *%@ = [[UISegmentedControl alloc]initWithItems:@[@\"第一条\",@\"第二条\"]];\n%@.frame = CGRectMake(0,0,300,150);\n%@.selectedSegmentIndex = 0;\n%@.tintColor = [UIColor redColor];\n%@.momentary = NO;\n[%@ addTarget:self action:@selector(%@Action:)forControlEvents:UIControlEventValueChanged];\n[self.view addSubview:%@];",className,className,className,className,className,className,className,className];
}
- (IBAction)addView:(id)sender {
    NSString *className = self.classNameTextField.stringValue.length>0?self.classNameTextField.stringValue:@"view";
    
    self.codeTextView.string = [NSString stringWithFormat:@"UIView *%@ = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];\n%@.backgroundColor = [UIColor redColor];\n[self.view addSubview:%@];",className,className,className];
}
- (IBAction)addPickerView:(id)sender {
    NSString *className = self.classNameTextField.stringValue.length>0?self.classNameTextField.stringValue:@"pickerView";
    
    self.codeTextView.string = [NSString stringWithFormat:@"UIPickerView *%@ = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 100, 320, 216)];\n%@.showsSelectionIndicator=YES;\n%@.dataSource = self;\n%@.delegate = self;\n[self.view addSubview:%@];",className,className,className,className,className];
}
- (IBAction)addDatePicker:(id)sender {
    NSString *className = self.classNameTextField.stringValue.length>0?self.classNameTextField.stringValue:@"datePicker";
    
    self.codeTextView.string = [NSString stringWithFormat:@"UIDatePicker *%@ = [ [ UIDatePicker alloc] initWithFrame:CGRectMake(0,0,320,216)];\n%@.datePickerMode = UIDatePickerModeDate;\n%@.minimumDate = [NSDate dateWithTimeIntervalSince1970:0];\n%@.maximumDate = [NSDate date];\n[self.view addSubview: %@];\n[%@ addTarget:self action:@selector(%@Changed:) forControlEvents:UIControlEventValueChanged];",className,className,className,className,className,className,className];
}
- (IBAction)addTextView:(id)sender {
    NSString *className = self.classNameTextField.stringValue.length>0?self.classNameTextField.stringValue:@"textView";
    
    self.codeTextView.string = [NSString stringWithFormat:@"UITextView *%@ = [[UITextView alloc]init];\n%@.backgroundColor = [UIColor lightGrayColor];\n%@.frame = CGRectMake(0, 0, 100, 100);\n%@.font = [UIFont systemFontOfSize:14.0];\n%@.textColor = [UIColor blackColor];\n%@.textAlignment = NSTextAlignmentLeft;\n[self.view addSubview:%@];",className,className,className,className,className,className,className];
}
- (IBAction)addTableView:(id)sender {
    NSString *className = self.classNameTextField.stringValue.length>0?self.classNameTextField.stringValue:@"tableView";
    
    self.codeTextView.string = [NSString stringWithFormat:@"UITableView *%@ = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];\n%@.delegate = self;\n%@.dataSource = self;\n[self.view addSubview:%@];",className,className,className,className];
}
- (IBAction)addCollectionView:(id)sender {
    NSString *className = self.classNameTextField.stringValue.length>0?self.classNameTextField.stringValue:@"collectionView";
    
    self.codeTextView.string = [NSString stringWithFormat:@"UICollectionViewFlowLayout *%@Layout = [[UICollectionViewFlowLayout alloc]init];\n%@Layout.itemSize = CGSizeMake(80, 80);\n%@Layout.scrollDirection = UICollectionViewScrollDirectionVertical;\n%@Layout.minimumLineSpacing = 10;\n%@Layout.minimumInteritemSpacing = 10;\n%@Layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);\nUICollectionView *%@ = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:%@Layout];\n%@.delegate = self;\n%@.dataSource = self;\n[self.view addSubview:%@];",className,className,className,className,className,className,className,className,className,className,className] ;
}

@end
