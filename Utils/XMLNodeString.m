//
//  XMLNodeString.h
//  iPhone Utility Package
//
//  Copyright 2009 mindfire solutions. All rights reserved.
//

#import "XMLNodeString.h"


@implementation XMLNodeString


- (NSMutableString*) xmlString
{
	return _str;
}

- (NSData*) dataWithUTFEncoding
{
	return [_str dataUsingEncoding: NSUTF8StringEncoding];
}

- (id) initWithString: (NSString*) string
{
	assert(string != nil);

	_str = [[NSMutableString stringWithString:string] retain];
	return self;
}

- (id) initWithTag: (NSString*) tag
{
	assert(tag != nil);

	_str = [[NSMutableString stringWithFormat:@"\n<%@>", tag] retain];
	_opentag = [tag retain];		// we need to close this tag
	return self;
}

- (id) initWithTag: (NSString*) tag strVal:(NSString*)strVal newLine:(BOOL)newLine
{
	_str = [NSMutableString stringWithString:[XMLNodeString stringWithTag:tag strVal:strVal newLine:newLine]];
	[_str retain];
	return self;
}

- (void) dealloc
{
	[_str release];
	[_openchildtag release];
	[_opentag release];
	
	[super dealloc];
}

#pragma mark -

- (void) startChildTag: (NSString*) tag propString:(NSString*)propString
{
	assert(tag != nil && _openchildtag == nil);

	[_str appendString:(_opentag != nil) ? @"\n\t" : @"\n"];

	if (propString)
		[_str appendFormat:@"<%@ %@>", tag, propString];
	else
		[_str appendFormat:@"<%@>", tag];
	
	if (_opentag == nil)
		_opentag = [tag retain];
	else
		_openchildtag = [tag retain];		// we need to close this tag
}


- (void) addChildNode: (NSString*) tag strVal:(NSString*)strVal
{
	NSString* str = [XMLNodeString stringWithTag:tag strVal:strVal newLine:NO];
	[self addChildNodeString:str newLine:NO];
}


- (void) addChildNode: (NSString*) tag intVal:(NSInteger)intVal
{
	NSString* xmlStr = [NSString stringWithFormat:@"\n<%@>%d</%@>", tag, intVal, tag];
	[self addChildNodeString:xmlStr newLine:NO];
}

- (void) addChildNode: (XMLNodeString*) xmlNode
{
	assert(xmlNode);
	[self addChildNodeString: [xmlNode xmlString] newLine:NO];
}

- (void) addChildNodeDictionary: (NSDictionary*) dictionary
{
	assert(dictionary);

	for (id key in dictionary)
		[self addChildNode: (NSString*)key strVal:(NSString*)[dictionary objectForKey:key]];
}

- (void) addChildNode: (NSString*) tag strValArray:(NSArray*)array
{
	assert(array);
	
	NSEnumerator *enumerator = [array objectEnumerator];
	id strVal = [enumerator nextObject];
	while (strVal)
	{
		[self addChildNode:tag strVal:(NSString*)strVal];
		strVal = [enumerator nextObject];
	}
}

- (void) addChildNodeString: (NSString*) nodeStr newLine:(BOOL)newLine
{
	if (newLine)
		nodeStr = [NSString stringWithFormat:@"\n%@", nodeStr];

	if (_opentag)
		nodeStr = [XMLNodeString stringWithTabAtNewLinesInString:nodeStr];
	if (_openchildtag)
		nodeStr = [XMLNodeString stringWithTabAtNewLinesInString:nodeStr];
	
	nodeStr = [nodeStr stringByReplacingOccurrencesOfString:@"& " withString:@"&amp; "];
	[_str appendString: nodeStr];
}


- (void) endCurrentTag
{
	if (_openchildtag != nil)
	{
		[_str appendFormat:@"\n\t</%@>", _openchildtag];
		[_openchildtag release];
		_openchildtag = nil;
	}
	else if (_opentag != nil)
	{
		[_str appendFormat:@"\n</%@>", _opentag];
		[_opentag release];
		_opentag = nil;
	}
}

#pragma mark -

+ (id) xmlNodeStringWithString: (NSString*) string
{
	XMLNodeString* node = [[XMLNodeString alloc] initWithString:string];
	return [node autorelease];	
}

+ (id) xmlNodeStringWithTag: (NSString*) tag
{
	XMLNodeString* node = [[XMLNodeString alloc] initWithTag: tag];
	return [node autorelease];	
}


+ (id) xmlNodeStringWithTag: (NSString*) tag strVal:(NSString*)strVal
{
	XMLNodeString* node = [XMLNodeString alloc];
	node = [node initWithTag:tag strVal:strVal newLine: NO];
	return [node autorelease];
}


+ (id) xmlNodeStringWithTag: (NSString*) tag intVal:(NSInteger)intVal
{
	NSString* strVal = [NSString stringWithFormat:@"%d", intVal];

	XMLNodeString* node = [XMLNodeString alloc];
	node = [node initWithTag:tag strVal:strVal newLine: NO];
	return [node autorelease];
}


+ (id) xmlNodeStringWithTag: (NSString*) tag xmlVal:(XMLNodeString*)xmlVal
{
	XMLNodeString* node = [XMLNodeString alloc];
	node = [node initWithTag:tag strVal:[xmlVal xmlString] newLine: YES];
	return [node autorelease];
}

+ (NSString*) stringWithTag: (NSString*) tag strVal:(NSString*)strVal newLine:(BOOL)newLine
{
	NSMutableString* str = [NSMutableString stringWithFormat:@"\n<%@>", tag];	
	if (strVal != nil)
	{
		if (newLine)
			[str appendFormat:@"\n%@\n</%@>", strVal, tag];
		else
			[str appendFormat:@"%@</%@>", strVal, tag];
	}
	else
	{
		[str appendFormat:@"</%@>", tag];		// don't bother about new line
	}
	
	return str;
}

+ (NSString*) stringWithTabAtNewLinesInString: (NSString*)string
{
	return [string stringByReplacingOccurrencesOfString:@"\n" withString:@"\n\t"];
}

@end

#pragma mark -

@implementation NSXMLNode (EasyAccessors)

- (NSDictionary*) dictionaryForNode
{
	NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] init];

	NSArray* children = [self children];
	for (int i = 0; i < [children count]; ++i)
	{
		NSXMLNode* child = [children objectAtIndex:i];
		if (child && [child kind] == GDataXMLElementKind)
		{
			[dictionary setObject:[child stringValueWithTrimming] forKey:[child name]];
		}
	}
	return [dictionary autorelease];
}

- (NSArray*) arrayWithValuesForName:(NSString *)name
{
	NSMutableArray* array = [[NSMutableArray alloc] init];
	
	NSArray* children = [self children];
	for (int i = 0; i < [children count]; ++i)
	{
		NSXMLNode* child = [children objectAtIndex:i];
		if (child && [child kind] == GDataXMLElementKind)
		{
			if ([[child name] isEqualToString:name])
				[array addObject:[child stringValueWithTrimming]];
		}
	}
	return [array autorelease];
}

- (NSString*) stringValueWithTrimming
{
	NSString* strVal = [self stringValue];
	if (strVal != nil)
		strVal = [strVal stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
	return strVal;	
}

- (NSString*) contentStringWithTrimming
{
	NSString* strVal = [self XMLString];
	
	NSString* tag = [NSString stringWithFormat:@"<%@>", [self name]];
	strVal = [strVal stringByReplacingOccurrencesOfString:tag withString:@""];

	tag = [NSString stringWithFormat:@"</%@>", [self name]];
	strVal = [strVal stringByReplacingOccurrencesOfString:tag withString:@""];

	if (strVal != nil)
		strVal = [strVal stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
	return strVal;	
}

@end

#pragma mark -

@implementation NSXMLElement (EasyAccessors)

-(GDataXMLElement *)elementForName:(NSString *)name
{	
	GDataXMLElement* element = nil;
	
	NSArray* array = [self elementsForName: name];
	if (array && [array count] > 0)
	{
		element = [array objectAtIndex: 0];
	}
	
	return element;
}

- (NSXMLElement*) elementLikeName:(NSString *)name
{
	NSArray* children = [self children];
	for (int i = 0; i < [children count]; ++i)
	{
		NSXMLNode* child = [children objectAtIndex:i];
		if (child && [child kind] == GDataXMLElementKind)
		{
			if ([[child name] rangeOfString:name].length > 0)
				return (NSXMLElement*)child;
		}
	}
	return nil;
}

- (NSString*) contentStringForNode: (NSString*)childNodeName
{
	assert(childNodeName != nil);

	NSXMLElement* childElement = [self elementForName:childNodeName];
	if (childElement)
	{
		return [childElement contentStringWithTrimming];
	}
	return nil;	
}


- (NSString*) stringValueForNode:(NSString*)childNodeName
{
	assert(childNodeName != nil);

	NSXMLElement* childElement = [self elementForName:childNodeName];
	if (childElement)
		return [childElement stringValueWithTrimming];

	return nil;
}

- (BOOL) boolValueForNode: (NSString*)childNodeName
{
	NSString* strVal = [self stringValueForNode:childNodeName];
	return [strVal boolValue];
}

- (NSInteger) integerValueForNode: (NSString*)childNodeName
{
	return [[self stringValueForNode:childNodeName] integerValue];
}

- (void) dumpNodes
{	
	NSArray* children = [self children];
	for (int i = 0; i < [children count]; ++i)
	{
		NSXMLNode* child = [children objectAtIndex:i];
		NSLog(@"%@", [child description]);
	}
}

#pragma mark -

- (NSString*) stringValueForAttribute: (NSString*)attributeName
{
	assert(attributeName != nil);
	
	GDataXMLNode* node = [self attributeForName:attributeName];
	if (node)
		return [node stringValueWithTrimming];
	
	return nil;
}

- (BOOL) boolValueForAttribute: (NSString*)attributeName
{
	NSString* strVal = [self stringValueForAttribute:attributeName];
	return [strVal boolValue];
}

- (NSInteger) integerValueForAttribute: (NSString*)attributeName
{
	return [[self stringValueForAttribute:attributeName] integerValue];
}

@end