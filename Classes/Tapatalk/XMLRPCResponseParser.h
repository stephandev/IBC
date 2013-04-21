//
//  XMLRPCResponseParser.h
//  IBC
//
//  Created by Manuel Burghard on 22.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    XMLRPCResultTypeNone,
    XMLRPCResultTypeArray,
    XMLRPCResultTypeDictionary
} XMLRPCResultType;

@class XMLRPCResponseParser;

@protocol XMLRPCResponseParserDelegate

- (void)parserDidFinishWithObject:(NSObject *)dictionaryOrArray ofType:(XMLRPCResultType)type;
- (void)parser:(XMLRPCResponseParser *)parser parseErrorOccurred:(NSError *)parseError;

@end

@interface XMLRPCResponseParser : NSObject <NSXMLParserDelegate> {
    NSXMLParser *xmlParser;
    NSMutableString *currentString;
    NSString *name;
    NSObject *value;
    NSArray *valueTypes;
    NSObject *currentObject;
    NSMutableArray *lastObjects;
    
    BOOL decodeBase64Data;
    
    id <XMLRPCResponseParserDelegate> __weak delegate;
    
}

@property (strong) NSXMLParser *xmlParser;
@property (strong) NSMutableString *currentString;
@property (strong) NSString *name;
@property (strong) NSObject *value;
@property (strong) NSArray *valueTypes;
@property (strong) NSObject *currentObject;
@property (strong) NSMutableArray *lastObjects;
@property (assign) BOOL decodeBase64Data; // Default is YES

@property (weak) id <XMLRPCResponseParserDelegate> delegate;


- (id)initWithData:(NSData *)data delegate:(id)delegate;
+ (XMLRPCResponseParser *)parserWithData:(NSData *)data delegate:(id)delegate;
- (BOOL)parse;
- (void)abortParsing;

@end
