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
    NSNumber *result = [self generateRandomIntegerBetween:0 and:10 inCaseError:&error];
    
    if (result == nil) {
        NSLog(@"there is an error");
        NSLog(@"Domain: %@ Code: %li", [error domain], [error code]);
        NSLog(@"Description: %@", [error localizedDescription]);
    } else {
        NSLog(@"Random Number: %i", [result intValue]);
    }
}

- (NSNumber *)generateRandomIntegerBetween:(int)minimum
                                       and:(int)maximum
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
