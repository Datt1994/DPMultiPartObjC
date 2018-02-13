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
    NSDictionary *dicParameetrs = @{
                                    @"a_id" : @"1",
                                    @"b_id" : @"3"
                                    };
    NSArray *arrFiles = @[
                          @{ multiPartFieldName:@"images[]"/*(if only 1 file upload don't use [])*/ ,
                             multiPartPathURL: @[@"file://xyz/....jpg" ,
                                                 @"file://xyz/....png"] },
                          @{ multiPartFieldName:@"video" ,
                             multiPartPathURL:@[@"file://xyz/....mp4"] },
                          @{ multiPartFieldName : @"pdf[]" ,
                             multiPartPathURL : @[@"file://xyz/....pdf" ,
                                                  @"file://xyz/....pdf"] }
                          ];
    
    [[multiPart sharedInstance] callPostWebService:@"www.xyz.com/../.."
                                        parameetrs:[[NSMutableDictionary alloc] initWithDictionary:dicParameetrs]
                                       filePathArr:arrFiles
                                        completion:^(NSDictionary *user, NSString *strErr, NSError *error) {
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
