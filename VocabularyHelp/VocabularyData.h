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
@property int total;
@property int notTested;
@property int easy;
@property int hard;
@property (copy) NSString *path;
@property (copy) NSString *level;
@property int doneThisTime;


-(void)Clear;

-(int)GetNextIndex;
-(void)SetRight:(int)index;
-(void)SetWrong:(int)index;

-(bool)LoadPath:(NSString*)path;
-(bool)SavePath:(NSString*)path;
-(bool)ConvertPath:(NSString*)path Name:(NSString*)name ToPath:(NSString *)topath;

+(VocabularyData *)getSharedInstance;
@end
