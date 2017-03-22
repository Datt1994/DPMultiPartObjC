//
//  multiPart.h
//  multipart
//
//  Created by datt on 3/22/17.
//  Copyright © 2017 datt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface multiPart : NSObject
typedef void(^multiPart_completion_block)(NSDictionary *user,NSString *, NSError *);
@property (nonatomic, strong) NSURLSession *session;
+(multiPart *)sharedInstance;
-(void)callPostWebService:(NSString *)url_String parameetrs:(NSMutableDictionary *)parameetrs imgVideoFilePathArr:(NSArray *)arrImgVideo parameetrNameOfPathArr:(NSString *)fieldName completion:(multiPart_completion_block)completion;
@end
