//
//  PNRequestProperty.m
//  PushServerTestApp
//
//  Created by Kay Czarnotta on 13.11.12.
//  Copyright 2012 EagleEye. All rights reserved.
//

#import "PNRequestProperty.h"


@implementation PNRequestProperty

@synthesize key;
@synthesize value;

-(PNRequestProperty*) initWithKey:(NSString *)k value:(NSString *)v
{
	self  = [super init];
	if(self)
	{
		[self setKey:k];
		[self setValue:v];
	}
	
	return self;
}

-(void)dealloc
{
	[key release];
	[value release];
    
	[super dealloc];
}


@end
