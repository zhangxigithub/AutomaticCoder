# Automatic Coder


## Overview
Automatic generate Objective-C code by JSON string.Support \<NSCoding\>.

Do you want other code?Tell me i'll add it.


## System
Xcode 4.4 or later

Mac OS 10.7 or later


## Feedback
<http://zhangxi.me>

<zhangxi_1989@sina.com>

```
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://zxapi.sinaapp.com"]];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *json = [data objectFromJSONData];
    
    //init object
    Person *person = [[Person alloc] initWithJson:json];
    NSLog(@"%@",person.name);                //http://zhangxi.me
    NSLog(@"%@",person.male?@"男":@"女");     //男
    NSLog(@"%ld",person.girlFriends.count);   //3
    
    
    //write to file
    BOOL result = [NSKeyedArchiver archiveRootObject:person toFile:@"./person.data"];
    NSLog(@"%@",result?@"success":@"failure");   //success

    
    //read from file
    Person *thePerson = [NSKeyedUnarchiver unarchiveObjectWithFile:@"./person.data"];
   
    NSLog(@"%@",thePerson.name);                //http://zhangxi.me
    NSLog(@"%@",thePerson.male?@"男":@"女");     //男
    NSLog(@"%ld",thePerson.girlFriends.count);   ///3

```
