import AppKit

class FloatingPanel: NSPanel {
    
    init() {
        super.init(
            contentRect: NSRect(x: 0, y: 0, width: 0, height: 0),
            styleMask: [.nonactivatingPanel, .titled, .closable, .fullSizeContentView],
            backing: .buffered,
            defer: false)
        
        // Allow the pannel to be on top of almost all other windows
        self.isFloatingPanel = true
        self.level = .floating
        
        // Allow the pannel to appear in a fullscreen space
        self.collectionBehavior.insert(.fullScreenAuxiliary)
        
        // While we may set a title for the window, don't show it
        self.titleVisibility = .hidden
        self.titlebarAppearsTransparent = true
        
        // Since there is no titlebar make the window moveable by click-dragging on the background
        self.isMovableByWindowBackground = true
    }
}
