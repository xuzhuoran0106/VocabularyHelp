//
//  OneWord.m
//  VocabularyHelp
//
//  Created by xu zhuoran on 6/19/14.
//  Copyright (c) 2014 xu zhuoran. All rights reserved.
//

#import "OneWord.h"

@implementation OneWord

-(id)init
{
    self = [super init];
    if (self)
    {
        _first=[NSString stringWithUTF8String:"First"];
        _second=[NSString stringWithUTF8String:"Second"];
        _meaning=[NSString stringWithUTF8String:"Meaning"];
        _comment=[NSString stringWithUTF8String:"Comment"];
        _count=0;
        _index=0;
        _tested=false;
    }
    
    return self;
}
-(bool)Save:(xml_node<>*)rootNode
{
    xml_document<> *doc = rootNode->document();
    
    xml_node<>* nodeIndex = doc->allocate_node(node_element,"index",doc->allocate_string([[NSString stringWithFormat:@"%d",_index] UTF8String]));
	rootNode->append_node(nodeIndex);
    
    xml_node<>* nodeFirst = doc->allocate_node(node_element,"first",doc->allocate_string([_first UTF8String]));
	rootNode->append_node(nodeFirst);
    
    xml_node<>* nodeSecond = doc->allocate_node(node_element,"second",doc->allocate_string([_second UTF8String]));
	rootNode->append_node(nodeSecond);
    
    xml_node<>* nodeMeaning = doc->allocate_node(node_element,"meaning",doc->allocate_string([_meaning UTF8String]));
	rootNode->append_node(nodeMeaning);
    
    xml_node<>* nodeComment = doc->allocate_node(node_element,"comment",doc->allocate_string([_comment UTF8String]));
	rootNode->append_node(nodeComment);
    
    xml_node<>* nodeCount = doc->allocate_node(node_element,"count",doc->allocate_string([[NSString stringWithFormat:@"%d",_count] UTF8String]));
	rootNode->append_node(nodeCount);
    
    xml_node<>* nodeTested = doc->allocate_node(node_element,"tested",doc->allocate_string([[NSString stringWithFormat:@"%d",_tested] UTF8String]));
	rootNode->append_node(nodeTested);
    
    return true;
}
-(bool)Load:(xml_node<>*)rootNode
{
    xml_node<>* nodeIndex = rootNode->first_node("index");
    _index = [[NSString stringWithUTF8String:nodeIndex->value()] intValue];
    
    xml_node<>* nodeFirst = rootNode->first_node("first");
    _first = [NSString stringWithUTF8String:nodeFirst->value()];
    
    xml_node<>* nodeSecond = rootNode->first_node("second");
    _second = [NSString stringWithUTF8String:nodeSecond->value()];
    
    xml_node<>* nodeMeaning = rootNode->first_node("meaning");
    _meaning = [NSString stringWithUTF8String:nodeMeaning->value()];
    
    xml_node<>* nodeComment = rootNode->first_node("comment");
    _comment = [NSString stringWithUTF8String:nodeComment->value()];
    
    xml_node<>* nodeCount = rootNode->first_node("count");
    _count = [[NSString stringWithUTF8String:nodeCount->value()] intValue];
    
    xml_node<>* nodeTested = rootNode->first_node("tested");
    _tested = [[NSString stringWithUTF8String:nodeTested->value()] intValue];
    
    return true;
}
@end
