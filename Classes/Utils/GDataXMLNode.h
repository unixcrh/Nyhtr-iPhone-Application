/* Copyright (c) 2008 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// These node, element, and document classes implement a subset of the methods
// provided by NSXML.  While NSXML behavior is mimicked as much as possible,
// there are important differences.
//
// The biggest difference is that, since this is based on libxml2, there
// is no retain model for the underlying node data.  Rather than copy every
// node obtained from a parse tree (which would have a substantial memory
// impact), we rely on weak references, and it is up to the code that
// created a document to retain it for as long as any
// references rely on nodes inside that document tree.


#import <Foundation/Foundation.h>

// libxml includes require that the target Header Search Paths contain
//
//   /usr/include/libxml2
//
// and Other Linker Flags contain
//
//   -lxml2

#import <libxml/tree.h>
#import <libxml/parser.h>
#import <libxml/xmlstring.h>
#import <libxml/xpath.h>
#import <libxml/xpathInternals.h>

#import "GDataDefines.h"

// Nomenclature for method names:
//
// Node = GData node
// XMLNode = xmlNodePtr
//
// So, for example:
//  + (id)nodeConsumingXMLNode:(xmlNodePtr)theXMLNode;

@class NSArray, NSDictionary, NSError, NSString, NSURL;
@class GDataXMLElement, GDataXMLDocument;

enum {
  GDataXMLInvalidKind = 0,
  GDataXMLDocumentKind,
  GDataXMLElementKind,
  GDataXMLAttributeKind,
  GDataXMLNamespaceKind,
  GDataXMLProcessingInstructionKind,
  GDataXMLCommentKind,
  GDataXMLTextKind,
  GDataXMLDTDKind,
  GDataXMLEntityDeclarationKind,
  GDataXMLAttributeDeclarationKind,
  GDataXMLElementDeclarationKind,
  GDataXMLNotationDeclarationKind
};

typedef NSUInteger GDataXMLNodeKind;

@interface GDataXMLNode : NSObject {
@protected
  // NSXMLNodes can have a namespace URI or prefix even if not part
  // of a tree; xmlNodes cannot.  When we create nodes apart from
  // a tree, we'll store the dangling prefix or URI in the xmlNode's name, 
  // like
  //   "prefix:name"
  // or 
  //   "{http://uri}:name"
  //
  // We will fix up the node's namespace and name (and those of any children) 
  // later when adding the node to a tree with addChild: or addAttribute:.
  // See fixUpNamespacesForNode:.
  
  xmlNodePtr xmlNode_; // may also be an xmlAttrPtr or xmlNsPtr
  BOOL shouldFreeXMLNode_; // if yes, xmlNode_ will be free'd in dealloc
  
  // cached values
  NSString *cachedName_;
  NSArray *cachedChildren_;
  NSArray *cachedAttributes_;
}

+ (GDataXMLElement *)elementWithName:(NSString *)name;				//Creates element as <name/>;
+ (GDataXMLElement *)elementWithName:(NSString *)name stringValue:(NSString *)value;	////Creates element as <name>value</name>;
+ (GDataXMLElement *)elementWithName:(NSString *)name URI:(NSString *)value;			//creates element as <{uri}:name/>

+ (id)attributeWithName:(NSString *)name stringValue:(NSString *)value;		//Creates element as <element attr = "value">value</element>

+ (id)attributeWithName:(NSString *)name									//Creates element as <element {uri}:attr = "value">value</element>
	URI:(NSString *)attributeURI stringValue:(NSString *)value;
																																

+ (id)namespaceWithName:(NSString *)name stringValue:(NSString *)value;		//Creates a valid namespace with the format xmlns:name = "value"

+ (id)textWithStringValue:(NSString *)value;								//Creates a simple text as the text node whose value is string value.
																			//Provides an alternative approach to add the text value to an XML element.	
-(NSString *)stringValue;													//Returns the string value of a node. For all types of nodes it gives the "value"
																	//or child text node as the value. For elements which have no child text node this returns "".

-(void)setStringValue:(NSString *)str;						//Sets the string value of an element or a node. This string value is treated as the child of type text node.

-(NSUInteger)childCount;									//Gives the total number of child counts of a particular xml node including text node children.
-(NSArray *)children;									//Gives all the children nodes of a particular node. Namespace node does not  have any children.
-(GDataXMLNode *)childAtIndex:(unsigned)index;

-(NSString *)localName;
-(NSString *)name;
-(NSString *)prefix;
-(NSString *)URI;

-(GDataXMLNodeKind)kind;

-(NSString *)XMLString;

+ (NSString *)localNameForName:(NSString *)name;
+ (NSString *)prefixForName:(NSString *)name;
-(NSArray *)nodesForXPath:(NSString *)xpath error:(NSError **)error;

@end


@interface GDataXMLElement : GDataXMLNode {
}

-(id)initWithXMLString:(NSString *)str error:(NSError **)error;

-(NSArray *)namespaces;
-(void)addNamespace:(GDataXMLNode *)aNamespace;

-(void)addChild:(GDataXMLNode *)child;

-(NSArray *)elementsForName:(NSString *)name;
-(NSArray *)elementsForLocalName:(NSString *)localName URI:(NSString *)URI;

-(NSArray *)attributes;
-(GDataXMLNode *)attributeForName:(NSString *)name;
-(GDataXMLNode *)attributeForLocalName:(NSString *)name URI:(NSString *)attributeURI;
-(void)addAttribute:(GDataXMLNode *)attribute;

-(NSString *)resolvePrefixForNamespaceURI:(NSString *)namespaceURI;
+(GDataXMLElement*)trimString:(NSString*)string FromStringValueOf:(GDataXMLElement*)element;

@end

@interface GDataXMLDocument : NSObject {
@protected
  xmlDoc* xmlDoc_; // strong; always free'd in dealloc
}

+ (id) xmlDocumentWithRootElement: (GDataXMLElement *)element;

-(id)initWithXMLString:(NSString *)str options:(unsigned int)mask error:(NSError **)error;
-(id)initWithData:(NSData *)data options:(unsigned int)mask error:(NSError **)error;
-(id)initWithRootElement:(GDataXMLElement *)element;

-(GDataXMLElement *)rootElement;

-(NSData *)XMLData;

-(void)setVersion:(NSString *)version;
-(void)setCharacterEncoding:(NSString *)encoding;

-(NSString *)description;
@end
