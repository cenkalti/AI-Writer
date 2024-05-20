import Cocoa
import SwiftUI
import AppKit

class ServiceProvider: NSObject {
    
    // MacOS calls this method when user requests the service by clicking menu item in sevices menu or pressing keyboard shortcut.
    // We have hard 30 seconds. If timeout occurs, MacOS shows error popup with following message:
    //
    //     The “Rewrite with AI” service could not be used because the “AI Writer.app” application did not respond to a request for services.
    //     Try reopening “AI Writer.app”, or contact the vendor for an updated version.
    //
    @objc func service(_ pasteboard: NSPasteboard, userData: String, error: AutoreleasingUnsafeMutablePointer<NSString>) {
        print("service call begin")
        guard let input = pasteboard.string(forType: .string) else {
            print("no string input")
            return
        }
        guard !input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            print("empty input")
            return
        }
        do {
            guard let output = try fetchReply(input: input) else {
                return
            }
            pasteboard.clearContents()
            pasteboard.setString(output, forType: .string)
            // Also, update the system clipboard for apps that might not support macOS text services, like Firefox.
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(output, forType: .string)
        } catch AppError.runtimeError(let message) {
            showError(message, title: "Error")
        } catch {
            showError(error.localizedDescription, title: "Unknown Error")
        }
        print("service call end")
    }
    
    func fetchReply(input: String) throws -> String? {
        // Create SwiftUI view with an input. This will begin fetching of reply from ChatGPT.
        let chatView = ChatView(input: input)
        
        // Show the chat view as modal floating panel window.
        presentFloatingPanel(chatView)
        
        switch chatView.viewModel.result {
        case .success(let output):
            return output
        case .failure(let error):
            throw error
        case .none:
            return nil
        }
    }
    
    func presentFloatingPanel(_ view: ChatView) {
        let panel = FloatingPanel()
        panel.contentView = NSHostingView(rootView: view)
        
        // Shows the panel and makes it active
        panel.center()
        panel.orderFront(nil)
        panel.makeKey()
        
        NSApp.runModal(for: panel)
        
        panel.close()
    }
}
