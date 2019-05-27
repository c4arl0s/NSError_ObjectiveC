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






