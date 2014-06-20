//
//  VocabularyMyView.m
//  VocabularyHelp
//
//  Created by xu zhuoran on 6/18/14.
//  Copyright (c) 2014 xu zhuoran. All rights reserved.
//

#import "VocabularyMyView.h"
#import "OneWord.h"
#import "VocabularyData.h"
#define kOFFSET_FOR_KEYBOARD 120.0

@interface VocabularyMyView ()
@property (weak, nonatomic) IBOutlet UIButton *ButtonRight;
@property (weak, nonatomic) IBOutlet UIButton *ButtonWrong;
@property (weak, nonatomic) IBOutlet UIButton *ButtonCheckAnswer;
@property (weak, nonatomic) IBOutlet UITextView *TextComment;
@property (weak, nonatomic) IBOutlet UILabel *TextMeaning;
@property (weak, nonatomic) IBOutlet UILabel *Textkana;
@property (weak, nonatomic) IBOutlet UILabel *TextKanji;
@property (weak, nonatomic) IBOutlet UILabel *NumNotTested;
@property (weak, nonatomic) IBOutlet UILabel *NumEasy;
@property (weak, nonatomic) IBOutlet UILabel *NumHard;
@property (weak, nonatomic) IBOutlet UILabel *NumCount;
@property (weak, nonatomic) IBOutlet UIButton *ButtonDone;
@property (weak, nonatomic) IBOutlet UILabel *TextDone;
@property (weak, nonatomic) IBOutlet UILabel *NumDone;

@end

@implementation VocabularyMyView
{
    //bool _oriRight;
    //bool _oriWrong;
    //bool _oriCheckAnswer;
    
    int _CurrentIndex;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //_oriRight=false;
    //_oriWrong=false;
    //_oriCheckAnswer=false;
    //
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil]; //
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillTerminate:)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil]; //
    [self LoadNext];
}
- (void)applicationWillTerminate:(UIApplication *)application
{
    if (_CurrentIndex<0)
    {
        return;
    }
    VocabularyData *data=[VocabularyData getSharedInstance];
    [data SavePath:data.path];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    if (_CurrentIndex<0)
    {
        return;
    }
    VocabularyData *data=[VocabularyData getSharedInstance];
    [data SavePath:data.path];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)LoadNext
{
    VocabularyData *data=[VocabularyData getSharedInstance];
    int index=[data GetNextIndex];
    
    _CurrentIndex=index;
    _TextComment.editable=false;
    _TextComment.selectable=false;
    _ButtonDone.enabled=false;
    
    _ButtonRight.enabled=false;
    _ButtonWrong.enabled=false;
    _ButtonCheckAnswer.enabled=true;
    
    if (index<0)
    {
        _ButtonRight.enabled=false;
        _ButtonWrong.enabled=false;
        _ButtonCheckAnswer.enabled=false;
        
        _TextKanji.text=@"";
        _Textkana.text=@"";
        _TextComment.text=@"";
        _TextMeaning.text=@"";
        
        _NumNotTested.text=@"";
        _NumEasy.text=@"";
        _NumHard.text=@"";
        _NumCount.text=@"";
        
        _NumDone.text=@"";
        return;
    }
    
    OneWord *one=data.data[index];
    
    if ([one.first length]==0)
    {
        _TextKanji.text=one.second;
    }
    else
    {
        _TextKanji.text=one.first;
    }
    _Textkana.text=@"";
    _TextComment.text=@"";
    _TextMeaning.text=@"";
    
    _NumNotTested.text=[NSString stringWithFormat:@"%d",data.notTested];
    _NumEasy.text=[NSString stringWithFormat:@"%d",data.easy];
    _NumHard.text=[NSString stringWithFormat:@"%d",data.hard];
    _NumCount.text=[NSString stringWithFormat:@"%d",one.count];
    
    _NumDone.text=[NSString stringWithFormat:@"%d",data.doneThisTime];
}
////////////////////////////////////////////////////////////////////////////////
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillResignActiveNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillTerminateNotification
                                                  object:nil];

    //save something
    if (_CurrentIndex<0)
    {
        return;
    }
    VocabularyData *data=[VocabularyData getSharedInstance];
    [data SavePath:data.path];
    [data Clear];
}
//////////////////////////////////////////////////////////////////////////////////
- (IBAction)ButtonCheckAnswer:(id)sender
{
    _ButtonRight.enabled=true;
    _ButtonWrong.enabled=true;
    _ButtonCheckAnswer.enabled=false;
    
    _TextComment.editable=true;
    _TextComment.selectable=true;
    _ButtonDone.enabled=true;
    
    if (_CurrentIndex<0)
    {
        return;
    }
    
    VocabularyData *data=[VocabularyData getSharedInstance];
    OneWord *one=data.data[_CurrentIndex];
    
    if (!([one.first length]==0))
    {
         _Textkana.text=one.second;
    }
    _TextComment.text=one.comment;
    _TextMeaning.text=one.meaning;
}
- (IBAction)ButtonRight:(id)sender
{
    _ButtonRight.enabled=false;
    _ButtonWrong.enabled=false;
    _ButtonCheckAnswer.enabled=true;
    
    if (_CurrentIndex<0)
    {
        return;
    }
    
    VocabularyData *data=[VocabularyData getSharedInstance];
    [data SetRight:_CurrentIndex];
    [self LoadNext];
}
- (IBAction)ButtonWrong:(id)sender
{
    _ButtonRight.enabled=false;
    _ButtonWrong.enabled=false;
    _ButtonCheckAnswer.enabled=true;
    
    if (_CurrentIndex<0)
    {
        return;
    }
    
    VocabularyData *data=[VocabularyData getSharedInstance];
    [data SetWrong:_CurrentIndex];
    [self LoadNext];
}

//////////////////////////////////////////////////////////////////////////////////
- (IBAction)ButtonTextDone:(id)sender
{
    [_TextComment resignFirstResponder];
    if (_CurrentIndex<0)
    {
        return;
    }
    
    VocabularyData *data=[VocabularyData getSharedInstance];
    OneWord *one=data.data[_CurrentIndex];
    one.comment=_TextComment.text;
}
//////
-(void)keyboardWillShow
{
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
//    else if (self.view.frame.origin.y < 0)
//    {
//        [self setViewMovedUp:NO];
//    }
    
    //_oriRight=_ButtonRight.enabled;
    //_oriWrong=_ButtonWrong.enabled;
    //_oriCheckAnswer=_ButtonCheckAnswer.enabled;
    
    _ButtonRight.enabled=false;
    _ButtonWrong.enabled=false;
    _ButtonCheckAnswer.enabled=false;
}

-(void)keyboardWillHide
{
//    if (self.view.frame.origin.y >= 0)
//    {
//        [self setViewMovedUp:YES];
//    }
//    else
    if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
    //_ButtonRight.enabled=_oriRight;
    //_ButtonWrong.enabled=_oriWrong;
    //_ButtonCheckAnswer.enabled=_oriCheckAnswer;
    _ButtonRight.enabled=true;
    _ButtonWrong.enabled=true;
    _ButtonCheckAnswer.enabled=false;
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

@end
