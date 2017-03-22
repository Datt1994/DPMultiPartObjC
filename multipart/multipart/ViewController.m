//
//  ViewController.m
//  multipart
//
//  Created by datt on 3/22/17.
//  Copyright © 2017 datt. All rights reserved.
//

#import "ViewController.h"
#import "multiPart.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[@"1",@"3"] forKeys:@[@"a_id", @"b_id"]];
    
    [[multiPart sharedInstance] callPostWebService:@"www.xyz.com/../.."
        parameetrs:[[NSMutableDictionary alloc] initWithDictionary:dic]
        imgVideoFilePathArr:@[@"file://xyz/....",@"file://xyz/...."]
        parameetrNameOfPathArr:@"images[](if only 1 file upload don't use [])"
        completion:^(NSDictionary *user, NSString *str, NSError *error)
     {
         if (!error) {
             NSLog(@"%@", user);
         }
     }];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
