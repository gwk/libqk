// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).

#import "qk-macros.h"
#import "qk-block-types.h"
#import "NSObject+QK.h"


@interface QKBinding : NSObject

// model cannot be weak; if it is, then removing the binding becomes impossible once it has been zeroed.
// view could be weak, but it does not seem helpful given the expected usage pattern. 
@property (nonatomic, unsafe_unretained, readonly) id model;
@property (nonatomic, unsafe_unretained, readonly) id view;
@property (nonatomic, readonly) NSString *modelKeyPath;
@property (nonatomic, readonly) NSString *viewKeyPath;

DEC_INIT(Model:(id)model
         path:(NSString *)modelKeyPath
         transform:(BlockMap)modelTransform
         view:(id)view
         path:(NSString *)viewKeyPath
         transform:(BlockMap)viewTransform);

// call to update both model and view; typically called by a control to submit a value.
// the optional model transform modifies the value passed to model;
// that value gets passed into the view transform, which is passed to the view.
- (void)updateValue:(id)value;
@end

