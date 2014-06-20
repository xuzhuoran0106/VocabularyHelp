//
//  OneWord.h
//  VocabularyHelp
//
//  Created by xu zhuoran on 6/19/14.
//  Copyright (c) 2014 xu zhuoran. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "rapidxml.hpp"
using namespace rapidxml;

@interface OneWord : NSObject
@property (copy) NSString *first;
@property (copy) NSString *second;
@property (copy) NSString *meaning;
@property (copy) NSString *comment;
@property int count;
@property int index;
@property bool tested;

-(bool)Save:(xml_node<>*)rootNode;
-(bool)Load:(xml_node<>*)rootNode;
@end
