import SwiftUI

// Resources:
// https://www.appsloveworld.com/coding/xcode/31/how-to-register-service-from-app-in-macos-application
// https://zachwaugh.com/posts/streaming-messages-chatgpt-swift-asyncsequence
// https://www.markusbodner.com/til/2021/02/08/create-a-spotlight/alfred-like-window-on-macos-with-swiftui/
// https://github.com/sindresorhus/LaunchAtLogin-Modern
// https://zachwaugh.com/posts/swiftui-blurred-window-background-macos

@main
struct AIWriterApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @Environment(\.openWindow) var openWindow
    
    var body: some Scene {
        MenuBarExtra("AI Writer", image: "MenuBarExtraIcon") {
            Button("Help") { appDelegate.openHelpWindow() }
                .keyboardShortcut(KeyEquivalent("H"), modifiers: .command)
            Button("Settings") { openWindow(id: "settings"); NSApp.activate(ignoringOtherApps: true) }
                .keyboardShortcut(KeyEquivalent(","), modifiers: .command)
            Button("Quit") { NSApplication.shared.terminate(nil) }
                .keyboardShortcut(KeyEquivalent("Q"), modifiers: .command)
        }
        
        Window("Settings", id: "settings") {
            SettingsView()
        }.windowResizability(.contentSize)
        
        // Help Window is not created here. It's created by AppDelegate.
        // This is because, I couldn't find a way to open a window programatically on launch with SwiftUI.
        // There is a scene onChange handler in macOS 14 but the application targets 13 for now.
    }
}
