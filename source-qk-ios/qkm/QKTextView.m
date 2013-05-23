// Copyright 2013 George King.
// Permission to use this file is granted in libqk/license.txt.


#import "qk-macros.h"
#import "UIColor+QK.h"
#import "UIView+QK.h"
#import "QKBinding.h"
#import "QKTextView.h"


@interface QKTextView () <UITextViewDelegate>

@property (nonatomic) UITextView* view;
@property (nonatomic) QKBinding* binding;
@property (nonatomic) UILabel* placeholderLabel;

@end


@implementation QKTextView


#pragma mark - NSObject


DEF_DEALLOC_DISSOLVE {
  DISSOLVE(_binding);
}


#pragma mark - UIView


- (id)initWithFrame:(CGRect)frame {
  INIT(super initWithFrame:frame);
  _view = [UITextView withFlexFrame:self.bounds];
  _view.delegate = self;
  _placeholderLabel = [UILabel withFlexFrame:CGRectInset(self.bounds, 8, 8)]; // UITextView has this fixed text inset.
  _placeholderLabel.font = _view.font;
  _placeholderLabel.textColor = [UIColor l:.5];
  _placeholderLabel.userInteractionEnabled = NO;
  [self addSubview:_view];
  [self addSubview:_placeholderLabel];
  return self;
}


#pragma mark - UITextViewDelegate


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
  BOOL b = APPLY_BLOCK_ELSE(_blockShouldBeginEditing, YES, self);
  if (b) {
    _placeholderLabel.hidden = YES;
  }
  return b;
}


- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
  BOOL b = APPLY_BLOCK_ELSE(_blockShouldEndEditing, YES, self);
  if (b) {
    _placeholderLabel.hidden = BIT(_view.hasText);
  }
  return b;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
  if (textView.returnKeyType != UIReturnKeyDefault && [text isEqualToString:@"\n"]) {
    [textView resignFirstResponder];
    return NO;
  }
  return APPLY_BLOCK_ELSE(_blockShouldChangeText, YES, self, range, text);
}


- (void)textViewDidBeginEditing:(UITextView *)textView {
  APPLY_LIVE_BLOCK(_blockEditingBegan, self);
}


- (void)textViewDidEndEditing:(UITextView *)textView {
  APPLY_LIVE_BLOCK(_blockEditingEnded, self);
}


- (void)textViewDidChange:(UITextView *)textView {
  APPLY_LIVE_BLOCK(_blockTextChanged, self);
}


- (void)textViewDidChangeSelection:(UITextView *)textView {
  APPLY_LIVE_BLOCK(_blockSelectionChanged, self);
}


#pragma  mark - QKTextView (UITextView aliases)


PROPERTY_ALIAS(BOOL, isEditable, Editable, _view.editable);

SUB_PROPERTY_ALIAS(UIColor*, textColor, TextColor, _view);
SUB_PROPERTY_ALIAS(NSDictionary*, typingAttributes, TypingAttributes, _view);
SUB_PROPERTY_ALIAS(UIDataDetectorTypes, dataDetectorTypes, DataDetectorTypes, _view);
SUB_PROPERTY_ALIAS(BOOL, allowsEditingTextAttributes, AllowsEditingTextAttributes, _view);
SUB_PROPERTY_ALIAS(BOOL, clearsOnInsertion, ClearsOnInsertion, _view);
SUB_PROPERTY_ALIAS(NSRange, selectedRange, SelectedRange, _view);

// these cause infinite recursion.
//SUB_PROPERTY_ALIAS(UIView*, inputView, InputView, _view);
//SUB_PROPERTY_ALIAS(UIView*, inputAccessoryView, InputAccessoryView, _view);

SUB_PROPERTY_ALIAS(UITextAutocapitalizationType, autocapitalizationType, AutocapitalizationType, _view);
SUB_PROPERTY_ALIAS(UITextAutocorrectionType, autocorrectionType, AutocorrectionType, _view);
SUB_PROPERTY_ALIAS(UITextSpellCheckingType, spellCheckingType, SpellCheckingType, _view);
SUB_PROPERTY_ALIAS(UIKeyboardType, keyboardType, KeyboardType, _view);
SUB_PROPERTY_ALIAS(UIKeyboardAppearance, keyboardAppearance, KeyboardAppearance, _view);
SUB_PROPERTY_ALIAS(UIReturnKeyType, returnKeyType, ReturnKeyType, _view);
SUB_PROPERTY_ALIAS(BOOL, enablesReturnKeyAutomatically, EnablesReturnKeyAutomatically, _view);
SUB_PROPERTY_ALIAS(BOOL, secureTextEntry, SecureTextEntry, _view);


- (NSString*)text {
  return _view.text;
}


- (void)setText:(NSString*)text {
  _view.text = text;
  _placeholderLabel.hidden = (text.length && !self.isFirstResponder);
}


- (NSAttributedString*)attributedText {
  return _view.attributedText;
}


- (void)setAttributedText:(NSAttributedString*)attributedText {
  _view.attributedText = attributedText;
  _placeholderLabel.hidden = (attributedText.length && !self.isFirstResponder);
}


- (UIFont*)font {
  return _view.font;
}


- (void)setFont:(UIFont *)font {
  _view.font = font;
  _placeholderLabel.font = font;
}


- (UITextAlignment)textAlignment {
  return _view.textAlignment;
}


- (void)setTextAlignment:(NSTextAlignment)textAlignment {
  _view.textAlignment = textAlignment;
  _placeholderLabel.textAlignment = textAlignment;
}


- (BOOL)hasText {
  return _view.hasText;
}


- (void)scrollRangeToVisible:(NSRange)range {
  [_view scrollRangeToVisible:range];
}


#pragma  mark - QKTextView


PROPERTY_ALIAS(NSString*, placeholder, Placeholder, _placeholderLabel.text);
PROPERTY_ALIAS(UIColor*, placeholderColor, PlaceholderColor, _placeholderLabel.textColor);


- (void)bindToModel:(id)model
               path:(NSString*)modelKeyPath
     modelTransform:(BlockMap)modelTransform
      viewTransform:(BlockMap)viewTransform {
  
  _binding = [QKBinding withModel:model path:modelKeyPath transform:nil view:self path:@"text" transform:viewTransform];
}


@end

