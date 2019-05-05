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

