//
//  multiPart.m
//  multipart
//
//  Created by datt on 3/22/17.
//  Copyright © 2017 datt. All rights reserved.
//

#import "multiPart.h"
#import <MobileCoreServices/MobileCoreServices.h>
static multiPart *objMultiPart = nil;
@implementation multiPart

+(multiPart *)sharedInstance {
    if (objMultiPart == nil) {
        objMultiPart = [[super allocWithZone:NULL] init];
    }
    return objMultiPart;
}
- (id)init {
    if (self = [super init]) {
    }
    return self;
}

-(void)callPostWebService:(NSString *)url_String parameetrs:(NSMutableDictionary *)parameetrs filePathArr:(NSArray *)arrFilePath completion:(multiPart_completion_block)completion
{
    @try {
        NSString *boundary = [self generateBoundaryString];
        
        // configure the request
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url_String]];
        [request setHTTPMethod:@"POST"];
        
        // set content type
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        // create body
        NSData *httpBody = [self createBodyWithBoundary:boundary parameters:parameetrs paths:arrFilePath];
        self.session = [NSURLSession sharedSession];
        // use sharedSession or create your own
        
        NSURLSessionTask *task = [self.session uploadTaskWithRequest:request fromData:httpBody completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error) {
                NSLog(@"error = %@", error);
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(nil,@"error",error);
                });
                return;
            }
            NSDictionary *user = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                if(completion)
                {
                    completion(user,@"Success",nil);
                    
                }
                else
                {
                    completion(nil,@"error",error);
                }
            });   
            // NSLog(@"result = %@", result);
        }];
        [task resume];
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}
- (NSData *)createBodyWithBoundary:(NSString *)boundary
                        parameters:(NSDictionary *)parameters
                             paths:(NSArray *)paths
{
    NSMutableData *httpBody = [NSMutableData data];
    
    // add params (all params are strings)
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *parameterKey, NSString *parameterValue, BOOL *stop) {
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameterKey] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"%@\r\n", parameterValue] dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    // add image data
    
    for (NSDictionary *pathDic in paths) {
        for (NSString *path in pathDic[multiPartPathURLs]) {
            NSString *filename  = [path lastPathComponent];
            NSData   *data      = [NSData dataWithContentsOfFile:path];
            NSString *mimetype  = [self mimeTypeForPath:path];
            
            [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", pathDic[multiPartFieldName], filename] dataUsingEncoding:NSUTF8StringEncoding]];
            [httpBody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimetype] dataUsingEncoding:NSUTF8StringEncoding]];
            [httpBody appendData:data];
            [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    [httpBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return httpBody;
}
- (NSString *)mimeTypeForPath:(NSString *)path
{
    // get a mime type for an extension using MobileCoreServices.framework
    
    CFStringRef extension = (__bridge CFStringRef)[path pathExtension];
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, extension, NULL);
    assert(UTI != NULL);
    
    NSString *mimetype = CFBridgingRelease(UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType));
    assert(mimetype != NULL);
    
    CFRelease(UTI);
    
    return mimetype;
}

- (NSString *)generateBoundaryString
{
    return [NSString stringWithFormat:@"Boundary-%@", [[NSUUID UUID] UUIDString]];
    
    // if supporting iOS versions prior to 6.0, you do something like:
    //
    // // generate boundary string
    // //
    // adapted from http://developer.apple.com/library/ios/#samplecode/SimpleURLConnections
    //
    // CFUUIDRef  uuid;
    // NSString  *uuidStr;
    //
    // uuid = CFUUIDCreate(NULL);
    // assert(uuid != NULL);
    //
    // uuidStr = CFBridgingRelease(CFUUIDCreateString(NULL, uuid));
    // assert(uuidStr != NULL);
    //
    // CFRelease(uuid);
    //
    // return uuidStr;
}

@end

