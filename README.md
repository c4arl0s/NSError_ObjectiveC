# NSError_ObjectiveC
NSError_ObjectiveC

- code
- domain
- userInfo

- localizedDescription
- localizedFailureReason
- recoverySuggestion
- localizedRecoveryOptions
- helpAnchor

initWithDomain:code:userInfo method can initialize custom error instances.

# Error domains

- Codes should be uniques within a single domain.

# Capturing errors

1. Declare an NSError variable.
2. Pass that error variable as a double pointer to a function that may result in an error. If anything goes wrong, the function will use this reference to record information about the error.
3. check the return value of that function for success or failure. If the operation failed, you can use NSError to handle the error yourself or display it to the use.

### - Some methods throws an error variable if it fails that method, and then you can pass that error to reference to an pointer error.
### - You can customize any method to throw and error

``` objective-c
//
//  ViewController.m
//  NSError_ObjectiveC
//
//  Created by Carlos Santiago Cruz on 5/5/19.
//  Copyright © 2019 Carlos Santiago Cruz. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSError *error = nil;
    NSNumber *result = [self generateRandomInteger:0 :-10 :&error];
    
    if (result == nil) {
        NSLog(@"there is an error");
        NSLog(@"Domain: %@ Code: %li", [error domain], [error code]);
        NSLog(@"Description: %@", [error localizedDescription]);
    } else {
        NSLog(@"Random Number: %i", [result intValue]);
    }
}

- (NSNumber *)generateRandomInteger :(int)minimum :(int)maximum :(NSError **)error
{
    if (minimum >= maximum) {
        if (error != NULL) {
            
            // Create the error.
            NSString *domain = @"com.MyCompany.RandomProject.ErrorDomain";
            int errorCode = 4;
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            [userInfo setObject:@"Maximum parameter is not greater than minimum parameter"
                         forKey:NSLocalizedDescriptionKey];
            
            // Populate the error reference.
            *error = [[NSError alloc] initWithDomain:domain
                                                code:errorCode
                                            userInfo:userInfo];
        }
        return nil;
    }
    return [NSNumber numberWithInt:arc4random_uniform((maximum - minimum) + 1) + minimum];
}

@end
```

``` console
2019-05-05 18:14:31.963177-0600 NSError_ObjectiveC[44773:2872899] there is an error
2019-05-05 18:14:31.963366-0600 NSError_ObjectiveC[44773:2872899] Domain: com.MyCompany.RandomProject.ErrorDomain Code: 4
2019-05-05 18:14:31.963491-0600 NSError_ObjectiveC[44773:2872899] Description: Maximum parameter is not greater than minimum parameter
```

# Test if you have a valid range.

``` objective-c
NSNumber *result = [self generateRandomInteger:5 :10 :&error];
```


``` console
2019-05-05 18:19:06.468847-0600 NSError_ObjectiveC[44833:2877282] Random Number: 9
```

# Take a look of how to declare the method

### if generateRandomIntegerBetween:12 and:10 inCaseError:&error

``` objective-c
//
//  ViewController.m
//  NSError_ObjectiveC
//
//  Created by Carlos Santiago Cruz on 5/5/19.
//  Copyright © 2019 Carlos Santiago Cruz. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSError *error = nil;
    NSNumber *result = [self generateRandomInteger:0 withMaximum:10 inCaseError:&error];
    
    if (result == nil) {
        NSLog(@"there is an error");
        NSLog(@"Domain: %@ Code: %li", [error domain], [error code]);
        NSLog(@"Description: %@", [error localizedDescription]);
    } else {
        NSLog(@"Random Number: %i", [result intValue]);
    }
}

- (NSNumber *)generateRandomInteger:(int)minimum
                        withMaximum:(int)maximum
                        inCaseError:(NSError **)error
{
    if (minimum >= maximum) {
        if (error != NULL) {
            
            // Create the error.
            NSString *domain = @"com.MyCompany.RandomProject.ErrorDomain";
            int errorCode = 4;
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            [userInfo setObject:@"Maximum parameter is not greater than minimum parameter"
                         forKey:NSLocalizedDescriptionKey];
            
            // Populate the error reference.
            *error = [[NSError alloc] initWithDomain:domain
                                                code:errorCode
                                            userInfo:userInfo];
        }
        return nil;
    }
    return [NSNumber numberWithInt:arc4random_uniform((maximum - minimum) + 1) + minimum];
}

@end
```

``` console
2019-05-27 21:05:41.560679-0500 NSError_ObjectiveC[3938:631585] there is an error
2019-05-27 21:05:41.560814-0500 NSError_ObjectiveC[3938:631585] Domain: com.MyCompany.RandomProject.ErrorDomain Code: 4
2019-05-27 21:05:41.560909-0500 NSError_ObjectiveC[3938:631585] Description: Maximum parameter is not greater than minimum parameter
```

# Some Methods Pass Errors by Reference

``` objective-c
- (BOOL)doSomethingThatMayGenerateAnError:(NSError **)errorPtr;
```

``` objective-c
- (BOOL)doSomethingThatMayGenerateAnError:(NSError **)errorPtr {
    ...
    // error occurred
    ...
    // If an error occurs, you should start by checking whether a non-NULL pointer was provided 
    // for the error parameter before you attempt to dereference it to set the error, 
    // before returning NO to indicate failure, I mean if verify if you call the funcion like this:
    // BOOL success = [self doSomethingThatMayGenerateAnError:nil];
    // if errorPtr = nil, do nothing
    // 
    if (errorPtr) {
        *errorPtr = [NSError errorWithDomain:...
                                        code:...
                                    userInfo:...];
    }
    return NO;
}
```

# According to documentation you have to evaluate first errorPtr != NULL and then assign the pointer error to error.

``` objective-c
//
//  ViewController.m
//  RecognizingSpeechInLiveAudio
//
//  Created by Carlos Santiago Cruz on 5/3/19.
//  Copyright © 2019 Carlos Santiago Cruz. All rights reserved.
//

#import "ViewController.h"
#import <Speech/Speech.h>
#import <EZAudio/EZAudio.h>


API_AVAILABLE(ios(10.0))
API_AVAILABLE(ios(10.0))
API_AVAILABLE(ios(10.0))
@interface ViewController () <SFSpeechRecognizerDelegate, AVAudioRecorderDelegate, UITextViewDelegate, EZMicrophoneDelegate>
{
    SFSpeechRecognizer *speechRecognizer;
    SFSpeechAudioBufferRecognitionRequest *speechAudioBufferRecognitionRequest;
    SFSpeechRecognitionTask *speechRecognitionTask;
    AVAudioEngine *audioEngine;
    // Obtain input audio-level data that you can use to provide level metering
    // note for documentation, importing <Speech/Speech.h>, you already import
    // ... <Foundation/Foundation.h> to create a pointer to AVAudioRecorder class
    AVAudioRecorder *audioRecorder;
    
    NSTimer *timerWithTenSeconds;
    NSTimer *levelTimer;
    NSTimer *initialTimer;
    
    float decibels;
    double lowPassResults;
    BOOL masNSegundos;
    
    EZAudioPlot *audioPlot;
    EZMicrophone *microphone;
}
@property (weak, nonatomic) IBOutlet UITextView *textViewRecognition;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 10.0, *)) {
        speechRecognizer = [[SFSpeechRecognizer alloc] initWithLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"es-MX"]];
    } else {
        // Fallback on earlier versions
    }
    audioEngine = [[AVAudioEngine alloc] init];
    // Disable recordButton until authorization is granded.
    [self.recordButton setEnabled:NO];
    // delegates properties
    _textViewRecognition.delegate = self;
    self->microphone = [EZMicrophone microphoneWithDelegate:self];
    
    CGFloat xTextView = _textViewRecognition.frame.origin.x;
    CGFloat yTextView = _textViewRecognition.frame.origin.y;
    CGFloat widthTextView = _textViewRecognition.frame.size.width;
    CGFloat heightTextView = _textViewRecognition.frame.size.height;
    CGFloat xPlotFrame = xTextView;
    CGFloat yPlotFrame = yTextView + widthTextView/3;;
    CGFloat widthPlotFrame = widthTextView;
    CGFloat heightPlotFrame = heightTextView/3;
    CGRect plotFrame = CGRectMake(xPlotFrame, yPlotFrame, widthPlotFrame, heightPlotFrame);
    audioPlot = [[EZAudioPlot alloc] initWithFrame:plotFrame];
    [self.view addSubview:audioPlot];
    audioPlot.backgroundColor = [UIColor colorWithRed:0.816 green:0.349 blue:0.255 alpha:1];
    audioPlot.color = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1];
    audioPlot.plotType = EZPlotTypeBuffer;
    audioPlot.shouldFill = YES;
    audioPlot.shouldMirror = YES;
    [self.view sendSubviewToBack:audioPlot];
}
- (void)microphone:(EZMicrophone *)microphone hasAudioReceived:(float **)buffer
                                                withBufferSize:(UInt32)bufferSize
                                        withNumberOfChannels:(UInt32)numberOfChannels
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->audioPlot updateBuffer:buffer[0] withBufferSize:bufferSize];
    });
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    // Configure AVAudioRecorder instace
    // recorderSettings dictionary is used to enable metering
    audioRecorder.delegate = self;
    NSString *temporaryDirectoryString = [NSTemporaryDirectory() stringByAppendingPathComponent:@"tmp.caf"];
    NSURL *urlForTemporaryDirectory = [NSURL URLWithString:temporaryDirectoryString];
    NSDictionary* audioRecorderSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithInt:kAudioFormatAppleIMA4], AVFormatIDKey,
                                      [NSNumber numberWithInt:44100], AVSampleRateKey,
                                      [NSNumber numberWithInt:1], AVNumberOfChannelsKey,
                                      [NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
                                      [NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,
                                      [NSNumber numberWithBool:NO], AVLinearPCMIsFloatKey, nil];
    NSError* audioRecorderError;
    audioRecorder = [[AVAudioRecorder alloc] initWithURL:urlForTemporaryDirectory
                                                settings:audioRecorderSettings
                                                   error:&audioRecorderError];
    if (!audioRecorderError) {
        NSLog(@"I found an error allocating audioRecorder: %@", audioRecorderError);
        NSLog(@"I will be not able to metering the sound");
    }
    
    // Configure the SFSpeechRecognizer object already stored in a local member variable.
    speechRecognizer.delegate = self;
    // Make the authorization request
    if (@available(iOS 10.0, *)) {
        [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
            [NSOperationQueue.mainQueue addOperationWithBlock:^{
                switch (status) {
                    case SFSpeechRecognizerAuthorizationStatusAuthorized:
                        [self.recordButton setEnabled:YES];
                        NSLog(@"Status: Authorized Recognizer");
                        break;
                    case  SFSpeechRecognizerAuthorizationStatusDenied:
                        [self.recordButton setEnabled:NO];
                        [self.recordButton setTitle:@"User denied access to speech recognition"
                                           forState:UIControlStateDisabled];
                        break;
                    case SFSpeechRecognizerAuthorizationStatusRestricted:
                        [self.recordButton setEnabled:NO];
                        [self.recordButton setTitle:@"Speech recognition restricted on this device"
                                           forState:UIControlStateDisabled];
                        break;
                    case SFSpeechRecognizerAuthorizationStatusNotDetermined:
                        [self.recordButton setEnabled:NO];
                        [self.recordButton setTitle:@"Speech recognition not yet authorized"
                                           forState:UIControlStateDisabled];
                        break;
                }
            }];
        }];
    } else {
        [self.recordButton setTitle:@"Your device has not iOS 10.0"
                           forState:UIControlStateDisabled];
    }
}

// MARK: SFSpeechRecognizerDelegate
- (void)speechRecognizer:(SFSpeechRecognizer *)speechRecognizer availabilityDidChange:(BOOL)available
API_AVAILABLE(ios(10.0)) {
    if (available) {
        [self.recordButton setEnabled:YES];
        [self.recordButton setTitle:@"Start Recording" forState:UIControlStateNormal];
        self.textViewRecognition.text = @"Speech recognition available again";
        self.recordButton.hidden = NO;
    } else {
        [self.recordButton setEnabled:NO];
        [self.recordButton setTitle:@"Recognition Not Available" forState:UIControlStateDisabled];
        self.textViewRecognition.text = @"Recognition Not Available";
        self.recordButton.hidden = YES;
    }
}

- (IBAction)recordButtonTapped:(id)sender {
    if ([audioEngine isRunning] || [audioRecorder isRecording]) {
        // update the title´s button to stopping
        [self.recordButton setTitle:@"Stopping Speech Recog and Recording" forState:UIControlStateDisabled];
        // Stop audio engine
        [audioEngine stop];
        // end audio for speech audio recognition request
        [speechAudioBufferRecognitionRequest endAudio];
        // Stop audioRecorder
        [audioRecorder stop];
        // disable the recordButton
        [self.recordButton setEnabled:NO];
        // Stop timers
        [timerWithTenSeconds invalidate];
        [levelTimer invalidate];
        [initialTimer invalidate];
        // stop feching audio in case the microphone is fetching audio
        [microphone stopFetchingAudio];
        
        [self.view sendSubviewToBack:audioPlot];

    } else {
        @try {
            // start recording if the audio engine si not running
            NSError *startRecordingError;
            BOOL success = [self startRecording:&startRecordingError];
            if (speechRecognizer.available && success) {
                    // if there is not error, do all the process of recording and recognition speech
                    // Documention suggest to enable metering until this point.
                    // Because metering uses computing resources, turn it on only if you intend to use it.
                    [audioRecorder prepareToRecord];
                    audioRecorder.meteringEnabled = YES;
                    [audioRecorder record];
                    [self.view addSubview:audioPlot];
                    [microphone startFetchingAudio];
                    // update the title of the record button once it stared to record
                    [self.recordButton setTitle:@"stop recording" forState:UIControlStateNormal];
                    // start the timer with 30 seconds of duration.
                    masNSegundos = NO;
                    timerWithTenSeconds = [NSTimer scheduledTimerWithTimeInterval:30.0
                                                                           target:self selector:@selector(stopTimerAndAudioEngineAndAudioRecorder)
                                                                         userInfo:nil
                                                                          repeats:NO];
                    levelTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                                  target:self
                                                                selector:@selector(levelTimerCallback)
                                                                userInfo:nil
                                                                 repeats:YES];
                    initialTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                                    target:self
                                                                  selector:@selector(validarInicioSpeech)
                                                                  userInfo:nil
                                                                   repeats:YES];
            } else {
                NSLog(@"Maybe SpeechRecognizer is not available or it was not successed the startingRecording %@", startRecordingError.localizedDescription);
                _textViewRecognition.text = @"I found an error, wait for availability";
            }
        } @catch (NSException *exception) {
            // According to documentation startRecording could deliver an exception
            [self.recordButton setTitle:@"Recording Not Available" forState:UIControlStateDisabled];
        }
    }
}

- (void)levelTimerCallback
{
    [audioRecorder updateMeters];
//    decibels = [audioRecorder averagePowerForChannel:0];
//    NSLog(@"decibels = %f", decibels);
//    if (decibels > -35) {
//        NSLog(@"You speaked aloud");
//    }
    const double ALPHA = 0.05;
    double peakPowerForChannel = pow(10, (0.05 * [audioRecorder peakPowerForChannel:0]));
    lowPassResults = ALPHA * peakPowerForChannel + (1.0 - ALPHA) * lowPassResults;
    
    if (lowPassResults < 0.1 && masNSegundos)
    {
        //NSLog(@"no detecto sonido");
        masNSegundos = NO;
        [audioRecorder stop];
        
    }  else {
        NSLog(@"He detectado sonido");
    }
}

- (void)stopTimerAndAudioEngineAndAudioRecorder
{
    [audioRecorder stop];
    [audioEngine stop];
    [timerWithTenSeconds invalidate];
    [levelTimer invalidate];
    [initialTimer invalidate];
    [speechAudioBufferRecognitionRequest endAudio];
    [microphone stopFetchingAudio];
    NSLog(@"30 seconds happened");
    [self.view sendSubviewToBack:audioPlot];
}

- (void)validarInicioSpeech
{
    NSLog(@"Han pasado 0.5 segundos");
    masNSegundos = YES;
}

- (BOOL)startRecording:(NSError **)errorPtr; // Remember put the code about throws
{
      // Cancel the previous task if it's running.
    if (speechRecognitionTask) {
        [speechRecognitionTask cancel];
        // be careful, the apple example put nil on self.recognitionTask, go back if it is necesary.
        speechRecognitionTask = nil;
        NSLog(@"You cancelled previous recognition task");
    }
    // Configure the audio session for the app, share an instance
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    @try {
        NSError *setCategoryError;
        if (@available(iOS 10.0, *)) {
            [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord
                                 mode:AVAudioSessionModeMeasurement
                              options:AVAudioSessionCategoryOptionDuckOthers
                                error:&setCategoryError];
            if (!audioSession) {
                *errorPtr = setCategoryError;
                NSLog(@"There is a Category error");
            }
        } else {
            // Fallback on earlier versions
        }
    } @catch (NSException *exception) {
        NSLog(@"There is an exception: %@", exception.reason);
        return NO;
    }
    @try {
        NSError *errorSetActive;
        [audioSession setActive:YES
                    withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation
                          error:&errorSetActive];
        if (!audioSession) {
            *errorPtr = errorSetActive;
            NSLog(@"There is an error Set Active");
        }
    } @catch (NSException *exception) {
        NSLog(@"There is an exception: %@", exception.reason);
        return NO;
    }
    
    AVAudioInputNode *audioInputNode = [audioEngine inputNode];
    
    // Create and configure the speech recognition request.
    if (@available(iOS 10.0, *)) {
        speechAudioBufferRecognitionRequest = [[SFSpeechAudioBufferRecognitionRequest alloc] init];
    } else {
        // Fallback on earlier versions
    }
    if (speechAudioBufferRecognitionRequest) {
        speechAudioBufferRecognitionRequest.shouldReportPartialResults = YES;
    } else {
        NSLog(@"Unable to create a SFSpeechAudioBufferRecognitionRequest object");
    }
    //Create a recognition task for the speech recognition session.
    if (@available(iOS 10.0, *)) {
        speechRecognitionTask = [speechRecognizer recognitionTaskWithRequest:speechAudioBufferRecognitionRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
            // keep a reference to the task so that it can be canceled.
            BOOL isFinal = NO;
            if (result) {
                self.textViewRecognition.text = result.bestTranscription.formattedString;
                isFinal = result.isFinal;
            }
            if (error != nil || isFinal) {
                if (errorPtr != NULL) {
                *errorPtr = error;
                    NSLog(@"Printing error code: %ld", (long)error.code);
                }
                //stop recognizing speech if there is a problem.
                [self->audioEngine stop];
                [audioInputNode removeTapOnBus:0];
                
                self->speechAudioBufferRecognitionRequest = nil;
                self->speechRecognitionTask = nil;
                
                [self->_recordButton setEnabled:YES];
                [self->_recordButton setTitle:@"Start recording"
                                     forState:UIControlStateNormal]; // check this out because apple is not explicit about the UIControl state.
            }
        }];
    } else {
        // Fallback on earlier versions
    }
    // Configure the microphone input
    AVAudioFormat *recordingFormat = [audioInputNode outputFormatForBus:0];
    [audioInputNode installTapOnBus:0
                         bufferSize:1024
                             format:recordingFormat block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        [self->speechAudioBufferRecognitionRequest appendAudioPCMBuffer:buffer];
    }];
    
    [audioEngine prepare];
    
    // According to Apple´s documentation, it could be ocurre an exception with startAndReturnError method.
    @try {
        NSError *startError;
        [audioEngine startAndReturnError:&startError];
        if (!audioEngine) {
            *errorPtr = startError;
            NSLog(@"There is an error at starting audio engine");
        }
    } @catch (NSException *exception) {
        NSLog(@"There is an exception: %@", exception.reason);
        return NO;
    }
    
    if(*errorPtr != nil)
    {
        NSLog(@"it found an error = %@", *errorPtr);
        
        return NO;
    } else {
        _textViewRecognition.text = @"Go ahead, I´m listening";
        return YES;
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"text view did change");
    return;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    NSLog(@"text view did end editing");
    return;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}

@end
```









