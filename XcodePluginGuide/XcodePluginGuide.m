//
//  XcodePluginGuide.m
//  XcodePluginGuide
//
//  Created by Isaac Overacker on 1/25/15.
//
//

#import "XcodePluginGuide.h"
#import "DTXcodeHeaders.h"
#import "DTXcodeUtils.h"

static XcodePluginGuide *sharedPlugin;

@interface XcodePluginGuide()

@property (nonatomic, strong, readwrite) NSBundle *bundle;
@end

@implementation XcodePluginGuide

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[self alloc] initWithBundle:plugin];
        });
    }
}

+ (instancetype)sharedPlugin
{
    return sharedPlugin;
}

- (id)initWithBundle:(NSBundle *)plugin
{
    if (self = [super init]) {
        // reference to plugin's bundle, for resource access
        self.bundle = plugin;
        
        // Sample menu item, nested under the "Edit" menu item.
        NSMenuItem *menuItem = [[NSApp mainMenu] itemWithTitle:@"Edit"];
        if (menuItem) {
            [[menuItem submenu] addItem:[NSMenuItem separatorItem]];
            NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:@"Do Action" action:@selector(doMenuAction) keyEquivalent:@""];
            [actionMenuItem setTarget:self];
            // Set ⌃⌘X as our plugin's keyboard shortcut.
            [actionMenuItem setKeyEquivalent:@"x"];
            [actionMenuItem setKeyEquivalentModifierMask:NSControlKeyMask | NSCommandKeyMask];

            [[menuItem submenu] addItem:actionMenuItem];
        }
    }
    return self;
}

- (void)doMenuAction
{
    // This is a reference to the current source code editor.
    DVTSourceTextView *sourceTextView = [DTXcodeUtils currentSourceTextView];
    // Get the range of the selected text within the source code editor.
    NSRange selectedTextRange = [sourceTextView selectedRange];
    // Get the selected text using the range from above.
    NSString *selectedString = [sourceTextView.textStorage.string substringWithRange:selectedTextRange];
    if (selectedString) {
        // Replace the selected string with a comment.
        [sourceTextView replaceCharactersInRange:selectedTextRange withString:@"// Malkovich Malkovich Malkovich"];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
