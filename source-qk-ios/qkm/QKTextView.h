// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


@class QKTextView;

typedef void (^BlockTextViewAction)(QKTextView*);
typedef BOOL (^BlockTextViewPredicate)(QKTextView*);
typedef BOOL (^BlockTextViewChangeText)(QKTextView*, NSRange range, NSString* replacementText);

@interface QKTextView : UIView

@property (nonatomic, copy) NSString* text;
@property (nonatomic, copy) NSAttributedString* attributedText;
@property (nonatomic, copy) NSString* placeholder;

@property (nonatomic) UIFont *font;
@property (nonatomic) UIColor *textColor;
@property (nonatomic) UIColor *placeholderColor;
@property (nonatomic, copy) NSDictionary* typingAttributes;

@property (nonatomic) NSTextAlignment textAlignment;
@property (nonatomic) UIDataDetectorTypes dataDetectorTypes;
@property (nonatomic, getter=isEditable) BOOL editable;
@property (nonatomic) BOOL allowsEditingTextAttributes;
@property (nonatomic) BOOL clearsOnInsertion;
@property (nonatomic) NSRange selectedRange;

// these cause infinite recursion.
//@property (nonatomic) UIView *inputView;
//@property (nonatomic) UIView *inputAccessoryView;

@property (nonatomic) UITextAutocapitalizationType autocapitalizationType;
@property (nonatomic) UITextAutocorrectionType autocorrectionType;
@property (nonatomic) UITextSpellCheckingType spellCheckingType;
@property (nonatomic) UIKeyboardType keyboardType;
@property (nonatomic) UIKeyboardAppearance keyboardAppearance;
@property (nonatomic) UIReturnKeyType returnKeyType;
@property (nonatomic) BOOL enablesReturnKeyAutomatically;
@property (nonatomic,getter=isSecureTextEntry) BOOL secureTextEntry;


@property (nonatomic, copy) BlockTextViewPredicate blockShouldBeginEditing;
@property (nonatomic, copy) BlockTextViewPredicate blockShouldEndEditing;
@property (nonatomic, copy) BlockTextViewChangeText blockShouldChangeText;
@property (nonatomic, copy) BlockTextViewAction blockEditingBegan;
@property (nonatomic, copy) BlockTextViewAction blockEditingEnded;
@property (nonatomic, copy) BlockTextViewAction blockTextChanged;
@property (nonatomic, copy) BlockTextViewAction blockSelectionChanged;

- (BOOL)hasText;
- (void)scrollRangeToVisible:(NSRange)range;

- (void)bindToModel:(id)model
               path:(NSString*)modelKeyPath
     modelTransform:(BlockMap)modelTransform
      viewTransform:(BlockMap)viewTransform;

@end

