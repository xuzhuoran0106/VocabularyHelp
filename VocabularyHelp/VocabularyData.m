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
    
    NSMutableArray* _lastChecked;
    int _lastCheckedLimit;
    
    int *_CurrentIndexPointer;
    
    BOOL _stopHard;
    
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
        _watchingList=[NSMutableArray array];
        
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
        _CurrentIndexPointer=NULL;
        
        _stopHard=false;
        
        _lastChecked=[NSMutableArray array];
        _lastCheckedLimit=5;
        _cIndex=-1;

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
    [_watchingList removeAllObjects];
    
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
    _CurrentIndexPointer=NULL;
    
    _stopHard=false;
    
    [_lastChecked removeAllObjects];
    _lastCheckedLimit=5;
    _cIndex=-1;

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
        
        [_watchingList removeAllObjects];
        xml_node<>* nodeWatchingList = xmlNet->first_node("watchingList");
        if(nodeWatchingList)
        {
            for (xml_node<>* oneNode = nodeWatchingList->first_node("index"); oneNode!=NULL; oneNode=oneNode->next_sibling())
            {
                NSNumber* one=[NSNumber numberWithInt:[[NSString stringWithUTF8String:oneNode->value()] intValue]];
                [_watchingList addObject:one];
            }
        }
        //--random hard set
        NSMutableArray *oriRndVec=[NSMutableArray array];
        for(int i=0;i<[_hardvec count];i++)
        {
            [oriRndVec addObject:_hardvec[i]];
        }
        [_hardvec removeAllObjects];
        while ([oriRndVec count]!=0)
        {
            int rndIndex=arc4random()%[oriRndVec count];
            [_hardvec addObject:oriRndVec[rndIndex]];
            [oriRndVec removeObjectAtIndex:rndIndex];
        }
        //--
        xml_node<>* nodeCurrentIndex = xmlNet->first_node("currentIndex");
        _currentIndex = [[NSString stringWithUTF8String:nodeCurrentIndex->value()] intValue];
        
        //
        _currentHardIndex=0;
        [_checked removeAllObjects];
        _HardCountAtLoad=[_hardvec count];
        _doneThisTime=0;
        _stopHard=false;
        [_lastChecked removeAllObjects];
        _cIndex=-1;
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
    NSString *tmpPath=[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[_level stringByAppendingString:@"Tmp.xml"]];
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
        
        xml_node<>* nodeWatchingList = doc.allocate_node(node_element,"watchingList",NULL);
        nodeVocabulary->append_node(nodeWatchingList);
        
        for (NSNumber *one in _watchingList)
        {
            xml_node<>* oneNode = doc.allocate_node(node_element,"index",doc.allocate_string([[NSString stringWithFormat:@"%d",[one intValue]] UTF8String]));
            nodeWatchingList->append_node(oneNode);
        }
        
        xml_node<>* nodeCurrentIndex = doc.allocate_node(node_element,"currentIndex",doc.allocate_string([[NSString stringWithFormat:@"%d",_currentIndex] UTF8String]));
        nodeVocabulary->append_node(nodeCurrentIndex);
        
        ofstream out([tmpPath UTF8String]);
        out << doc;
        out.close();
    }
    catch(...)
    {
        return FALSE;
    }
    try
    {
        NSFileManager *manager = [NSFileManager defaultManager];
        if ([manager fileExistsAtPath:path])
        {
            [manager removeItemAtPath:path error:nil];
        }
        [manager copyItemAtPath:tmpPath toPath:path error:nil];
    }
    catch(...)
    {
        return false;
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
        [self ResetToinitial];
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
-(void)ResetToinitial
{
    _total=[_data count];
    _notTested=_total;
    _easy=0;
    _hard=0;
    //
    [_easyVec removeAllObjects];
    [_hardvec removeAllObjects];
    [_midvec removeAllObjects];
    [_watchingList removeAllObjects];
    //
    NSMutableArray *oriRndVec=[NSMutableArray array];
    for(int i=0;i<[_data count];i++)
    {
        [oriRndVec addObject:[NSNumber numberWithInt:i]];
        OneWord *one= _data[i];
        one.count=10;
        one.tested = false;
    }
    while ([oriRndVec count]!=0)
    {
        int rndIndex=arc4random()%[oriRndVec count];
        [_midvec addObject:oriRndVec[rndIndex]];
        [oriRndVec removeObjectAtIndex:rndIndex];
    }
    //
    _currentIndex=0;
    _cIndex=-1;

}
-(int)GetNextIndex
{
    _cIndex=[self _GetNextIndex];
    return _cIndex;
}
-(int)_GetNextIndex
{
    _CurrentIndexPointer=NULL;
    if([_path isEqualToString:[NSString stringWithUTF8String:"Not Loaded"]])
        return -1;
    
    if ([_checked count]>100)
    {
        return [(NSNumber*)_checked[arc4random()%[_checked count]] intValue];
    }
    //if (_currentHardIndex<min((double)_HardCountAtLoad,(double)[_hardvec count]))//[_hardvec count]
    if (_currentHardIndex<[_hardvec count] && _stopHard==false)//
    {
        if (arc4random()%100<10+_currentHardIndex && [_hardvec count]>0 && _currentHardIndex>0)
        {
            int resIndex= [(NSNumber*)_hardvec[arc4random()%_currentHardIndex] intValue];
            
            if (![_lastChecked containsObject:[NSNumber numberWithInt:resIndex]])
            {
                return resIndex;
            }
        }
        
        int old = _currentHardIndex;
        _CurrentIndexPointer=&_currentHardIndex;
        return [(NSNumber*)_hardvec[old] intValue];
    }
    
    if (_currentIndex<[_midvec count])
    {
        if (arc4random()%100<10+[_hardvec count] && [_hardvec count]>0)
        {
            int resIndex= [(NSNumber*)_hardvec[arc4random()%[_hardvec count]] intValue];
            
            if (![_lastChecked containsObject:[NSNumber numberWithInt:resIndex]])
            {
                return resIndex;
            }
        }
        
        for(int i=0;i<_lastCheckedLimit;i++)
        {
            int old = _currentIndex;
            _CurrentIndexPointer=&_currentIndex;
            int resIndex= [(NSNumber*)_midvec[old] intValue];
            
            if (![_lastChecked containsObject:[NSNumber numberWithInt:resIndex]])
            {
                return resIndex;
            }
            _currentIndex++;
            if(_currentIndex>=[_midvec count])
            {
                _currentIndex=0;
            }
        }
    }
//    else if ([_midvec count]==0 && [_hardvec count]>0)
//    {
//        if (arc4random()%100<40+[_hardvec count] && [_hardvec count]>0)
//        {
//            resIndex= [(NSNumber*)_hardvec[arc4random()%[_hardvec count]] intValue];
//        }
//    }
    if ([_easyVec count]>0)
    {
        if (arc4random()%100<10+[_hardvec count] && [_hardvec count]>0)
        {
            int resIndex= [(NSNumber*)_hardvec[arc4random()%[_hardvec count]] intValue];
            
            if (![_lastChecked containsObject:[NSNumber numberWithInt:resIndex]])
            {
                return resIndex;
            }
        }

        return [(NSNumber*)_easyVec[arc4random()%[_easyVec count]] intValue];
    }
    if([_data count] > 0)
        return arc4random()%[_data count];
    return 0;
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
            int midIndex=[_midvec indexOfObject:[NSNumber numberWithInt:index]];
            if(midIndex <= _currentIndex)
                _currentIndex--;
            [_midvec removeObject:[NSNumber numberWithInt:index]];
        }
        
        if ([_hardvec containsObject:[NSNumber numberWithInt:index]])
        {
            int hardIndex=[_hardvec indexOfObject:[NSNumber numberWithInt:index]];
            if(hardIndex <= _currentHardIndex)
                _currentHardIndex--;
            [_hardvec removeObject:[NSNumber numberWithInt:index]];
        }
    }
    else if (one.count<=10 && one.count!= 8 &&![_midvec containsObject:[NSNumber numberWithInt:index]])
    {
        [_midvec addObject:[NSNumber numberWithInt:index]];
        
        if ([_hardvec containsObject:[NSNumber numberWithInt:index]])
        {
            int hardIndex=[_hardvec indexOfObject:[NSNumber numberWithInt:index]];
            if(hardIndex <= _currentHardIndex)
                _currentHardIndex--;
            [_hardvec removeObject:[NSNumber numberWithInt:index]];
        }
        
        if ([_easyVec containsObject:[NSNumber numberWithInt:index]])
        {
            [_easyVec removeObject:[NSNumber numberWithInt:index]];
        }
    }
    //
    [self SetCommonBehavior:one Index:index];
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
    one.count = min(13,one.count);
    //
    if (one.count>=11&&![_hardvec containsObject:[NSNumber numberWithInt:index]])
    {
        [_hardvec addObject:[NSNumber numberWithInt:index]];
        
        if ([_midvec containsObject:[NSNumber numberWithInt:index]])
        {
            int midIndex=[_midvec indexOfObject:[NSNumber numberWithInt:index]];
            if(midIndex <= _currentIndex)
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
            int hardIndex=[_hardvec indexOfObject:[NSNumber numberWithInt:index]];
            if(hardIndex <= _currentHardIndex)
                _currentHardIndex--;
            [_hardvec removeObject:[NSNumber numberWithInt:index]];
        }
        
        if ([_easyVec containsObject:[NSNumber numberWithInt:index]])
        {
            [_easyVec removeObject:[NSNumber numberWithInt:index]];
        }
    }
    //
    [self SetCommonBehavior:one Index:index];
}
-(void)SetCommonBehavior:(OneWord*)one Index:(int)index
{
    if (_CurrentIndexPointer)
    {
        *_CurrentIndexPointer = *_CurrentIndexPointer+1;
    }
    if (_currentHardIndex>=[_hardvec count])
    {
        _stopHard = true;
    }
    if(_currentIndex>=[_midvec count])
    {
        _currentIndex=0;
    }
    if(one.tested==false)
    {
        one.tested=true;
        _notTested--;
    }
    _easy = [_easyVec count];
    _hard = [_hardvec count];
    //
    [_lastChecked addObject:[NSNumber numberWithInt:index]];
    if ([_lastChecked count]>_lastCheckedLimit)
    {
        [_lastChecked removeObjectAtIndex:0];
    }
    if (![_checked containsObject:[NSNumber numberWithInt:index]])
    {
        [_checked addObject:[NSNumber numberWithInt:index]];
    }
     _doneThisTime=[_checked count];
    //
    _SaveCount++;
    if (_SaveCount>30)
    {
        [self SavePath:_path];
        _SaveCount=0;
    }
}
-(bool)AddToWatchingList:(int)index
{
    if (index<0)
    {
        return false;
    }
    if (![_watchingList containsObject:[NSNumber numberWithInt:index]])
    {
        [_watchingList addObject:[NSNumber numberWithInt:index]];
        return true;
    }
    return false;
}
@end
