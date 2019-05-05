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



