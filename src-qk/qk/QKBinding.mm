// Copyright 2013 George King.
// Permission to use this file is granted in license-libqk.txt (ISC License).


#import "qk-macros.h"
#import "qk-log.h"
#import "QKBinding.h"


@interface QKBinding ()

@property (nonatomic, unsafe_unretained) id model;
@property (nonatomic, unsafe_unretained) id view;
@property (nonatomic) NSString *modelKeyPath;
@property (nonatomic) NSString *viewKeyPath;
@property (nonatomic, copy) BlockMap modelTransform;
@property (nonatomic, copy) BlockMap viewTransform;

@end


@implementation QKBinding


#pragma mark - NSObject


DEF_DEALLOC_DISSOLVE {
  if (_model) {
    errFL(@"dissolve %@", self);
    [_model removeObserver:self forKeyPath:_modelKeyPath];
    _model = nil;
    _modelTransform = nil;
    _view = nil;
    _viewTransform = nil;
  }
}


- (NSString *)description {
  return [NSString stringWithFormat:@"<QKBinding %p: m: %p '%@' %@; v: %p '%@' %@>",
          self, _model, _modelKeyPath, _modelTransform, _view, _viewKeyPath, _viewTransform];
}


- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
  
  qk_assert(object == _model, @"QKBinding observed unexpected object: %@;\n  key path: %@;\n  binding: %@", object, keyPath, self);
  [_view setValue:[object valueForKeyPath:keyPath] forKeyPath:_viewKeyPath];
}


#pragma mark - QKBinding


DEF_INIT(Model:(id)model
         path:(NSString *)modelKeyPath
         transform:(BlockMap)modelTransform
         view:(id)view
         path:(NSString *)viewKeyPath
         transform:(BlockMap)viewTransform) {
  
  qk_assert(model && modelKeyPath, @"nil model/keyPath");
  qk_assert(view && viewKeyPath, @"nil view/keyPath");
  
  _model = model;
  _modelKeyPath = modelKeyPath;
  _modelTransform = modelTransform;
  _view = view;
  _viewKeyPath = viewKeyPath;
  _viewTransform = viewTransform;
  [_model addObserver:self forKeyPath:_modelKeyPath options:0 context:NULL];
  [self updateValue:[model valueForKeyPath:_modelKeyPath]];
  return self;
}


- (void)updateValue:(id)value {
  id m = APPLY_BLOCK_OR_IDENTITY(_modelTransform, value);
  [_model setValue:m forKeyPath:_modelKeyPath];
  id v = APPLY_BLOCK_OR_IDENTITY(_viewTransform, m); // m, not value
  [_view setValue:v forKeyPath:_viewKeyPath];
}


@end
