//
//  VocabularyData.h
//  VocabularyHelp
//
//  Created by xu zhuoran on 6/19/14.
//  Copyright (c) 2014 xu zhuoran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VocabularyData : NSObject
@property (copy)NSMutableArray* data;
@property (copy)NSMutableArray* watchingList;
@property int total;
@property int notTested;
@property int easy;
@property int hard;
@property (copy) NSString *path;
@property (copy) NSString *level;
@property int doneThisTime;

@property int currentIndex;


-(void)Clear;
-(void)ResetToinitial;

-(int)GetNextIndex;
-(void)SetRight:(int)index;
-(void)SetWrong:(int)index;

-(bool)LoadPath:(NSString*)path;
-(bool)SavePath:(NSString*)path;
-(bool)ConvertPath:(NSString*)path Name:(NSString*)name ToPath:(NSString *)topath;

-(bool)AddToWatchingList:(int)index;

+(VocabularyData *)getSharedInstance;
@end
