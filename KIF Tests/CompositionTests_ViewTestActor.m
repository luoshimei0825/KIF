//
//  NewCompositionTests.m
//  KIF
//
//  Created by Alex Odawa on 1/27/15.
//
//

#import <KIF/KIF.h>
#import "UIApplication-KIFAdditions.h"
#import "UIAccessibilityElement-KIFAdditions.h"

@interface KIFUIViewTestActor (Composition)

- (void)tapViewIfNotSelected:(NSString *)label;
- (void)tapViewWithAccessibilityHint:(NSString *)hint;

@end

@implementation KIFUIViewTestActor (Composition)

- (void)tapViewIfNotSelected:(NSString *)label
{
    UIAccessibilityElement *element = [viewTester usingLabel:label].element;
    if ((element.accessibilityTraits & UIAccessibilityTraitSelected) == UIAccessibilityTraitNone) {
        [[[viewTester usingLabel:label] usingPredicateWithFormat:@"(accessibilityTraits & %i) == %i", UIAccessibilityTraitSelected, UIAccessibilityTraitNone] tap];
    }
}

- (void)tapViewWithAccessibilityHint:(NSString *)hint
{
    [[viewTester usingPredicateWithFormat:@"accessibilityHint like %@", hint] tap];
}

@end

@interface CompositionTests_ViewTestActor : KIFTestCase
@end

@implementation CompositionTests_ViewTestActor

- (void)beforeEach
{
    [[viewTester usingLabel:@"Show/Hide"] tap];
}

- (void)afterEach
{
    [[[viewTester usingLabel:@"Test Suite"] usingTraits:UIAccessibilityTraitButton] tap];
}

- (void)testTappingViewWithHint
{
    [viewTester tapViewWithAccessibilityHint:@"A button for A"];
    [tester waitForViewWithAccessibilityLabel:@"A" traits:UIAccessibilityTraitSelected];
}

- (void)testTappingOnlyIfNotSelected
{
    [viewTester tapViewIfNotSelected:@"A"];
    [tester waitForViewWithAccessibilityLabel:@"A" traits:UIAccessibilityTraitSelected];

    // This should not deselect the element.
    [viewTester tapViewIfNotSelected:@"A"];
    [tester waitForViewWithAccessibilityLabel:@"A" traits:UIAccessibilityTraitSelected];
}

@end
