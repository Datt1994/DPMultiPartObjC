//
//  multiPart.h
//  multipart
//
//  Created by datt on 3/22/17.
//  Copyright © 2017 datt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
static NSString *multiPartFieldName = @"fieldName";
static NSString *multiPartPathURLs = @"pathURL";
@interface multiPart : NSObject
typedef void(^multiPart_completion_block)(NSDictionary *user, NSString *strErr, NSError *error);
@property (nonatomic, strong) NSURLSession *session;
+(multiPart *)sharedInstance;
-(void)callPostWebService:(NSString *)url_String parameetrs:(NSMutableDictionary *)parameetrs filePathArr:(NSArray *)arrFilePath completion:(multiPart_completion_block)completion;
@end
