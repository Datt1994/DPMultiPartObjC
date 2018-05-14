## multiPart
Upload videos , images and other files(pdf, doc,..) using multiPart class objective C 

**For Swift** :- [MultiPartSwift](https://github.com/Datt1994/MultiPartSwift)

**Step 1**:-  Copy & paste `multiPart.h` & `multiPart.m` files into your project 

**Step 2**:-  Usage 
```objc
    #import "multiPart.h"

    NSString *imgPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"jpeg"];
    NSDictionary *dicParameetrs = @{
                                    @"a_id" : @"1",
                                    @"name" : @"datt"
                                    };
    NSArray *arrFiles = @[
                          @{ multiPartFieldName:@"images[]"/*(if only 1 file upload don't use [])*/ ,
                             multiPartPathURLs: @[imgPath ,
                                                  imgPath ,
                                                 @"file://xyz/....png"] },
                          @{ multiPartFieldName:@"video" ,
                             multiPartPathURLs:@[@"file://xyz/....mp4"] },
                          @{ multiPartFieldName : @"pdf[]" ,
                             multiPartPathURLs : @[@"file://xyz/....pdf" ,
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
```
