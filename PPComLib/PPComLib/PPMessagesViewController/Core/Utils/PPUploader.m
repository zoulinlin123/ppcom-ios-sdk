//
//  PPUploader.m
//  PPComDemo
//
//  Created by Kun Zhao on 9/28/15.
//  Copyright (c) 2015 Yvertical. All rights reserved.
//

#import "PPUploader.h"
#import "PPFileManager.h"
#import "PPComUtils.h"

@interface PPUploader ()

@property PPCom *client;
@property (nonatomic) PPFileManager *fileManager;

-(NSString*)uploadFile:(NSString*)fileUrl host:(NSString*)hostUrl;

@end

@implementation PPUploader

#pragma mark - Initiazlie Methods

-(instancetype)initWithClient:(PPCom *)client {
    if (self = [super initWithClient:client]) {
        _client = client;
    }
    return self;
}

#pragma mark - Getter Methods

-(PPFileManager*)fileManager {
    if (_fileManager == nil) {
        _fileManager = [[PPFileManager alloc] init];
    }
    return _fileManager;
}

#pragma mark - Upload Methods

-(void)uploadTxt:(NSString *)text fromUserId:(NSString*)userUuid withDelegate:(void (^)(NSError *, NSDictionary *))delegate {
    [self.fileManager writeTextToFile:text withDelegate:^(NSException *exception, NSString *filePath) {
        if (!exception) {
            [self uploadFile:filePath fromUserId:userUuid withDelegate:delegate];
        } else {
            if (delegate != nil) {
                NSError *error = [[NSError alloc] init];
                delegate(error, nil);
            }
        }
    }];
}

-(void)uploadFile:(NSString *)fileUrl fromUserId:(NSString*)userUuid withDelegate:(void (^)(NSError *, NSDictionary *))delegate {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *jsonResponse = [self uploadFile:fileUrl fromUserId:userUuid host:PPFileUploadHost];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (delegate) {
                delegate(nil, [self.client.utils jsonStringToDictionary:jsonResponse]);
            }
        });
    });
}

-(void)uploadImageData:(NSData *)data name:(NSString*)fileName fromUserId:(NSString*)userUuid withDelegate:(void (^)(NSError *, NSDictionary *))delegate {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *jsonResponse = [self uploadData:data fileName:fileName fromUserId:userUuid host:PPFileUploadHost];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (delegate) {
                delegate(nil, [self.client.utils jsonStringToDictionary:jsonResponse]);
            }
        });
    });
}


-(NSString*)uploadFile:(NSString*)fileUrl fromUserId:(NSString*)userUuid host:(NSString*)hostUrl {
    
    NSData* fileData =[NSData dataWithContentsOfFile:fileUrl];
    return [self uploadData:fileData fileName:[fileUrl lastPathComponent] fromUserId:userUuid host:hostUrl];
}


-(NSString*)uploadData:(NSData*)data fileName:(NSString*)fileName fromUserId:(NSString*)userUuid host:(NSString*)hostUrl {
    NSString *urlString = hostUrl;
    
    /*init*/
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    NSString *boundary = @"----WebKitFormBoundaryamroXVL2GK8a89eH";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    
    /*add header*/
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    /*add header*/
    [request addValue:@"keep-alive" forHTTPHeaderField: @"Connection"];
    
    /*add body*/
    NSMutableData *postbody = [NSMutableData data];
    
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[@"Content-Disposition: form-data; name=\"upload_type\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[@"file" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[@"Content-Disposition: form-data; name=\"subtype\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[@"FILE" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[@"Content-Disposition: form-data; name=\"user_uuid\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[userUuid dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"", fileName] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[@"\r\nContent-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSString* tmp = [[NSString alloc] initWithData:postbody encoding:NSUTF8StringEncoding];
    
    NSLog(@"post body %@", tmp);
    //add file
    [postbody appendData:data];
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    /*add header*/
    [request addValue:[NSString stringWithFormat:@"%d",postbody.length] forHTTPHeaderField: @"Content-Length"];
    
    [request setHTTPBody:postbody];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    return returnString;
}
@end
