//
//  PNRequestProperty.h
//  PushServerTestApp
//
//  Created by Kay Czarnotta on 13.11.12.
//  Copyright 2012 EagleEye. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PNRequestProperty : NSObject {
	
@private
	NSString *key;
	NSString *value;
}

- (PNRequestProperty*) initWithKey:(NSString*) key value:(NSString*) value;

@property (readwrite,copy) NSString* key;
@property (readwrite,copy) NSString* value;
@end
