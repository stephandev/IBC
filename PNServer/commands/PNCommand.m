//
//  PNRegisterCommand.m
//  PushServerTestApp
//
//  Created by Kay Czarnotta on 15.11.12.
//  Copyright 2012 EagleEye. All rights reserved.
//

#import "PNCommand.h"


@implementation PNCommand

@synthesize requestDelegate;
@synthesize pnConnection;

-(id)  initWithConnection:(PNPushServerConnection*) c delegate:(id<PNRequestDelegate>)d
{
	self = [self init];
	if(self)
	{
		[self setPnConnection:c];
		[self setRequestDelegate:d];
	}
	return self;
}

-(void) dealloc
{
    NSLog(@"PNCommand dealoc");
    
	[serverUrl release];
	//[requestData release];
	//[httpMethod release];
	[connection release];
	[responseData release];
//	[requestDelegate release];
	[pnConnection release];
	
	[super dealloc];
}

-(void)execute
{
	NSLog(@"Prepare request");
	if(![self createRequest])
	{
		[requestDelegate requestCanceled: pnConnection];
		return;
	}
	
	NSLog(@"Create request %@", serverUrl);
	
	NSURL* url =  [NSURL URLWithString: serverUrl];
	
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:15.0];
    //requestWithURL:url];
	[request setHTTPMethod:httpMethod];
    
	
    if(![self prepareRequest:request])
	{
		[requestDelegate requestCanceled: pnConnection];
		return;
	}
	
    // NSTimeInterval interval = 30.0;
    
    //   request.timeoutInterval=10.0;
    //    [request setTimeIntervall: 5.0];
    
    if(requestData)
        [request setHTTPBody: requestData];
	
    if (connection)
        [connection release];
    
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	if(!connection)
	{
		NSLog(@"error creating request");
		//doooof
		return;
	}
}


- (void)connection:(NSURLConnection *)c didReceiveResponse:(NSURLResponse *)response
{
	NSLog(@"Response started"); 
	
	NSHTTPURLResponse* newResponse = (NSHTTPURLResponse*)  response;
	httpErrorCode = [newResponse statusCode];
	NSLog(@"Statuscode: %d",httpErrorCode);
	responseData = [[NSMutableData alloc]init];
}

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)d
{
	NSLog(@"Did didReceiveData: ");
    [responseData appendData:d];
}

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
	NSLog(@"Request error: %@",error);
    [requestDelegate requestCanceled:pnConnection];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
	NSLog(@"Did FinishLoading");
	
    NSString *jsonText = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	[self receiveRequest:jsonText httpErrorCode: httpErrorCode];
   	[jsonText release];
}

-(void)receiveRequest:(NSString *)response httpErrorCode:(int)ec
{
    if(httpErrorCode==200)
        [requestDelegate requestSucceed: pnConnection];
    else
        [requestDelegate requestFailed: pnConnection];
}

-(Boolean) prepareRequest:(NSURLRequest*) request
{
	return true;
}

-(Boolean) createRequest
{
	return true;
}

@end
