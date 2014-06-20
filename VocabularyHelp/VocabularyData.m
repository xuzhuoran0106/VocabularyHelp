//
//  VocabularyData.m
//  VocabularyHelp
//
//  Created by xu zhuoran on 6/19/14.
//  Copyright (c) 2014 xu zhuoran. All rights reserved.
//

#import "VocabularyData.h"
#include "rapidxml.hpp"
#include "rapidxml_utils.hpp"
#include "rapidxml_print.hpp"
#include <string>
#import "OneWord.h"
using namespace rapidxml;
using namespace std;

static VocabularyData *sharedInstance = nil;

@implementation VocabularyData
{
    int _SaveCount;
    int _currentIndex;
    int _currentHardIndex;
    int _HardCountAtLoad;
    
    NSMutableArray* _easyVec;
    NSMutableArray* _midvec;
    NSMutableArray* _hardvec;
    
    NSMutableArray* _checked;
    
}
-(id)init
{
    self = [super init];
    if (self)
    {
        _data=[NSMutableArray array];
        _easyVec=[NSMutableArray array];//
        _midvec=[NSMutableArray array];//
        _hardvec=[NSMutableArray array];//
        _checked=[NSMutableArray array];
        
        _total=0;
        _notTested=0;
        _easy=0;
        _hard=0;
        _path=[NSString stringWithUTF8String:"Not Loaded"];
        _level=[NSString stringWithUTF8String:"Unknown"];
        _SaveCount=0;

        _currentIndex=0;//
        _currentHardIndex=0;
        _HardCountAtLoad=0;
        
        _doneThisTime=0;
    }
    
    return self;
}
-(void)Clear
{
    [_data removeAllObjects];
    [_easyVec removeAllObjects];
    [_midvec removeAllObjects];
    [_hardvec removeAllObjects];
    [_checked removeAllObjects];
    
    _total=0;
    _notTested=0;
    _easy=0;
    _hard=0;
    _path=[NSString stringWithUTF8String:"Not Loaded"];
    _level=[NSString stringWithUTF8String:"Unknown"];
    _SaveCount=0;
    
    _currentIndex=0;//
    _currentHardIndex=0;
    _HardCountAtLoad=0;
    
    _doneThisTime=0;
}
+(VocabularyData *)getSharedInstance
{
    @synchronized(self)
    {
        if(sharedInstance == nil)
        {
            sharedInstance = [[self alloc] init];
        }
    }
    return sharedInstance;
}

-(bool)LoadPath:(NSString*)path
{
    _path=path;
    try
    {
        xml_document<> doc;
        file<> fdoc([path UTF8String]);
        doc.parse<0>(fdoc.data());
        //
        xml_node<>* xmlNet = doc.first_node();
		////
		xml_node<>* nodeLevel = xmlNet->first_node("level");
        _level = [NSString stringWithUTF8String:nodeLevel->value()];
        
        xml_node<>* nodeTotal = xmlNet->first_node("total");
        _total = [[NSString stringWithUTF8String:nodeTotal->value()] intValue];
        
        xml_node<>* nodeNotTested = xmlNet->first_node("notTested");
        _notTested = [[NSString stringWithUTF8String:nodeNotTested->value()] intValue];
        
        xml_node<>* nodeEasy = xmlNet->first_node("easy");
        _easy = [[NSString stringWithUTF8String:nodeEasy->value()] intValue];
        
        xml_node<>* nodeHard = xmlNet->first_node("hard");
        _hard = [[NSString stringWithUTF8String:nodeHard->value()] intValue];
        
        xml_node<>* nodeData = xmlNet->first_node("Data");
        [_data removeAllObjects];
        for (xml_node<>* oneNode = nodeData->first_node("OneNode"); oneNode!=NULL; oneNode=oneNode->next_sibling())
        {
            OneWord* one=[[OneWord alloc] init];
            [one Load:oneNode];
            [_data addObject:one];
        }
        //
        [_easyVec removeAllObjects];
        xml_node<>* nodeEasyVec = xmlNet->first_node("easyVec");
        for (xml_node<>* oneNode = nodeEasyVec->first_node("index"); oneNode!=NULL; oneNode=oneNode->next_sibling())
        {
            NSNumber* one=[NSNumber numberWithInt:[[NSString stringWithUTF8String:oneNode->value()] intValue]];
            [_easyVec addObject:one];
        }
        
        [_midvec removeAllObjects];
        xml_node<>* nodeMidVec = xmlNet->first_node("midVec");
        for (xml_node<>* oneNode = nodeMidVec->first_node("index"); oneNode!=NULL; oneNode=oneNode->next_sibling())
        {
            NSNumber* one=[NSNumber numberWithInt:[[NSString stringWithUTF8String:oneNode->value()] intValue]];
            [_midvec addObject:one];
        }
        
        [_hardvec removeAllObjects];
        xml_node<>* nodehardVec = xmlNet->first_node("hardVec");
        for (xml_node<>* oneNode = nodehardVec->first_node("index"); oneNode!=NULL; oneNode=oneNode->next_sibling())
        {
            NSNumber* one=[NSNumber numberWithInt:[[NSString stringWithUTF8String:oneNode->value()] intValue]];
            [_hardvec addObject:one];
        }
        
        xml_node<>* nodeCurrentIndex = xmlNet->first_node("currentIndex");
        _currentIndex = [[NSString stringWithUTF8String:nodeCurrentIndex->value()] intValue];
        
        //
        _currentHardIndex=0;
        [_checked removeAllObjects];
        _HardCountAtLoad=[_hardvec count];
        _doneThisTime=0;
    }
    catch(...)
    {
        return FALSE;
    }
    return true;
}
-(bool)SavePath:(NSString*)path
{
    if([_path isEqualToString:[NSString stringWithUTF8String:"Not Loaded"]])
        return false;
    try
    {
        xml_document<> doc;
        
        doc.remove_all_nodes();
        
        xml_node<>* rot = doc.allocate_node(rapidxml::node_pi,doc.allocate_string("xml version='1.0' encoding='utf-8'"));
        doc.append_node(rot);
        
        xml_node<>* nodeVocabulary = doc.allocate_node(node_element,"Vocabulary",NULL);
        doc.append_node(nodeVocabulary);
        
        xml_node<>* nodeLevel = doc.allocate_node(node_element,"level",doc.allocate_string([_level UTF8String]));
        nodeVocabulary->append_node(nodeLevel);
        xml_node<>* nodeTotal = doc.allocate_node(node_element,"total",doc.allocate_string([[NSString stringWithFormat:@"%d",_total] UTF8String]));
        nodeVocabulary->append_node(nodeTotal);
        xml_node<>* nodeNotTested = doc.allocate_node(node_element,"notTested",doc.allocate_string([[NSString stringWithFormat:@"%d",_notTested] UTF8String]));
        nodeVocabulary->append_node(nodeNotTested);
        xml_node<>* nodeEasy = doc.allocate_node(node_element,"easy",doc.allocate_string([[NSString stringWithFormat:@"%d",_easy] UTF8String]));
        nodeVocabulary->append_node(nodeEasy);
        xml_node<>* nodeHard = doc.allocate_node(node_element,"hard",doc.allocate_string([[NSString stringWithFormat:@"%d",_hard] UTF8String]));
        nodeVocabulary->append_node(nodeHard);
        
        xml_node<>* nodeData = doc.allocate_node(node_element,"Data",NULL);
        nodeVocabulary->append_node(nodeData);
        
        for (OneWord *one in _data)
        {
            xml_node<>* oneNode = doc.allocate_node(node_element,"OneNode",NULL);
            nodeData->append_node(oneNode);

            [one Save:oneNode];
        }
        
        xml_node<>* nodeEasyVec = doc.allocate_node(node_element,"easyVec",NULL);
        nodeVocabulary->append_node(nodeEasyVec);

        for (NSNumber*one in _easyVec)
        {
            xml_node<>* oneNode = doc.allocate_node(node_element,"index",doc.allocate_string([[NSString stringWithFormat:@"%d",[one intValue]] UTF8String]));
            nodeEasyVec->append_node(oneNode);
        }
        
        xml_node<>* nodeMidVec = doc.allocate_node(node_element,"midVec",NULL);
        nodeVocabulary->append_node(nodeMidVec);
        
        for (NSNumber*one in _midvec)
        {
            xml_node<>* oneNode = doc.allocate_node(node_element,"index",doc.allocate_string([[NSString stringWithFormat:@"%d",[one intValue]] UTF8String]));
            nodeMidVec->append_node(oneNode);
        }
        
        xml_node<>* nodeHardVec = doc.allocate_node(node_element,"hardVec",NULL);
        nodeVocabulary->append_node(nodeHardVec);
        
        for (NSNumber*one in _hardvec)
        {
            xml_node<>* oneNode = doc.allocate_node(node_element,"index",doc.allocate_string([[NSString stringWithFormat:@"%d",[one intValue]] UTF8String]));
            nodeHardVec->append_node(oneNode);
        }
        
        xml_node<>* nodeCurrentIndex = doc.allocate_node(node_element,"currentIndex",doc.allocate_string([[NSString stringWithFormat:@"%d",_currentIndex] UTF8String]));
        nodeVocabulary->append_node(nodeCurrentIndex);
        
        ofstream out([path UTF8String]);
        out << doc;
        out.close();
    }
    catch(...)
    {
        return FALSE;
    }
    return true;
}
-(bool)ConvertPath:(NSString*)path Name:(NSString*)name ToPath:(NSString *)topath
{
    _path=topath;
    _level=name;
    try
    {
        [_data removeAllObjects];
        NSArray *fileData;
        NSError *error;
        fileData = [[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error] componentsSeparatedByString:@"\n"];
        int count=0;
        for (NSString* oneNode in fileData)
        {
            try
            {
                if([oneNode length]==0)
                    continue;
                NSArray *nodeData=[oneNode componentsSeparatedByString:@"/"];
                OneWord* one=[[OneWord alloc] init];
            
                one.first=[nodeData[0] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\t"]];
                one.second=[nodeData[1] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\t"]];
                one.meaning=[nodeData[2] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\t"]];
                one.comment=[nodeData[3] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\t"]];
                one.index=count;
                one.count=10;
                one.tested = false;
                [_data addObject:one];
                count++;
            }
            catch(...)
            {
                
            }
        }
        //
        _total=[_data count];
         _notTested=_total;
        _easy=0;
        _hard=0;
        //
        [_easyVec removeAllObjects];
        [_hardvec removeAllObjects];
        [_midvec removeAllObjects];
        for(int i=0;i<[_data count];i++)
        {
            [_midvec addObject:[NSNumber numberWithInt:i]];
        }
        _currentIndex=0;
        //
        if(![self SavePath:_path])
            throw 0;
    }
    catch(...)
    {
        return FALSE;
    }
    return true;
}
-(int)GetNextIndex
{
    if([_path isEqualToString:[NSString stringWithUTF8String:"Not Loaded"]])
        return -1;
    if ([_checked count]>100)
    {
        return [(NSNumber*)_checked[arc4random()%[_checked count]] intValue];
    }
    if (_currentHardIndex<min((double)_HardCountAtLoad,(double)[_hardvec count]))//[_hardvec count]
    {
        int old = _currentHardIndex;
        _currentHardIndex++;
        return [(NSNumber*)_hardvec[old] intValue];
    }
    if (_currentIndex<[_midvec count])
    {
        if (arc4random()%100<10)
        {
            return [(NSNumber*)_hardvec[arc4random()%[_hardvec count]] intValue];
        }
        int old = _currentIndex;
        _currentIndex++;
        _doneThisTime++;
        return [(NSNumber*)_midvec[old] intValue];
    }
    return arc4random()%[_data count];
}
-(void)SetRight:(int)index
{
    if(index<0)
        return;
    if([_path isEqualToString:[NSString stringWithUTF8String:"Not Loaded"]])
        return;
    OneWord *one =  _data[index];
    //
    one.count -= 1;
    one.count = max(8,one.count);
    //
    if (one.count==8&&![_easyVec containsObject:[NSNumber numberWithInt:index]])
    {
        [_easyVec addObject:[NSNumber numberWithInt:index]];
        
        if ([_midvec containsObject:[NSNumber numberWithInt:index]])
        {
            _currentIndex--;
            [_midvec removeObject:[NSNumber numberWithInt:index]];
        }
        
        if ([_hardvec containsObject:[NSNumber numberWithInt:index]])
        {
            _currentHardIndex--;
            [_hardvec removeObject:[NSNumber numberWithInt:index]];
        }
    }
    else if (one.count<=10 && one.count!= 8 &&![_midvec containsObject:[NSNumber numberWithInt:index]])
    {
        [_midvec addObject:[NSNumber numberWithInt:index]];
        
        if ([_hardvec containsObject:[NSNumber numberWithInt:index]])
        {
            _currentHardIndex--;
            [_hardvec removeObject:[NSNumber numberWithInt:index]];
        }
        
        if ([_easyVec containsObject:[NSNumber numberWithInt:index]])
        {
            [_easyVec removeObject:[NSNumber numberWithInt:index]];
        }
    }
    //
    if(one.tested==false)
    {
        one.tested=true;
        _notTested--;
    }
    _easy = [_easyVec count];
    _hard = [_hardvec count];
    if (![_checked containsObject:[NSNumber numberWithInt:index]])
    {
        [_checked addObject:[NSNumber numberWithInt:index]];
    }
    //
    _SaveCount++;
    if (_SaveCount>30)
    {
        [self SavePath:_path];
        _SaveCount=0;
    }
}
-(void)SetWrong:(int)index
{
    if(index<0)
        return;
    if([_path isEqualToString:[NSString stringWithUTF8String:"Not Loaded"]])
        return;
    OneWord *one =  _data[index];
    //
    one.count += 3;
    one.count = min(20,one.count);
    //
    if (one.count>=11&&![_hardvec containsObject:[NSNumber numberWithInt:index]])
    {
        [_hardvec addObject:[NSNumber numberWithInt:index]];
        
        if ([_midvec containsObject:[NSNumber numberWithInt:index]])
        {
            _currentIndex--;
            [_midvec removeObject:[NSNumber numberWithInt:index]];
        }
        
        if ([_easyVec containsObject:[NSNumber numberWithInt:index]])
        {
            [_easyVec removeObject:[NSNumber numberWithInt:index]];
        }
      
    }
    else if (one.count>8 && one.count <11 &&![_midvec containsObject:[NSNumber numberWithInt:index]])
    {
        [_midvec addObject:[NSNumber numberWithInt:index]];
        
        if ([_hardvec containsObject:[NSNumber numberWithInt:index]])
        {
            _currentHardIndex--;
            [_hardvec removeObject:[NSNumber numberWithInt:index]];
        }
        
        if ([_easyVec containsObject:[NSNumber numberWithInt:index]])
        {
            [_easyVec removeObject:[NSNumber numberWithInt:index]];
        }
    }
    //
    if(one.tested==false)
    {
        one.tested=true;
        _notTested--;
    }
    _easy = [_easyVec count];
    _hard = [_hardvec count];
    if (![_checked containsObject:[NSNumber numberWithInt:index]])
    {
        [_checked addObject:[NSNumber numberWithInt:index]];
    }
    //
    _SaveCount++;
    if (_SaveCount>30)
    {
        [self SavePath:_path];
        _SaveCount=0;
    }
}

@end
