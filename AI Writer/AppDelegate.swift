import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    
    var helpWindow: NSWindow!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setServiceProvider()
        createHelpWindow()
        if !isLaunchedAsLogInItem() {
            openHelpWindow()
        }
    }
    
    func setServiceProvider() {
        print("setting services provider")
        NSApplication.shared.servicesProvider = ServiceProvider()
        NSUpdateDynamicServices()
    }
    
    func isLaunchedAsLogInItem() -> Bool {
        let event = NSAppleEventManager.shared().currentAppleEvent
        return
            event?.eventID == kAEOpenApplication &&
            event?.paramDescriptor(forKeyword: keyAEPropData)?.enumCodeValue == keyAELaunchedAsLogInItem
    }
    
    func createHelpWindow() {
        let helpView = HelpView()
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 0, height: 0),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.isReleasedWhenClosed = false
        window.contentView = NSHostingView(rootView: helpView)
        self.helpWindow = window
    }
    
    func openHelpWindow() {
        helpWindow.center()
        helpWindow.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}
