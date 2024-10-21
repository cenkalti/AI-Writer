import SwiftUI

struct HelpView: View {
    
    @Environment(\.openWindow) var openWindow
    
    let projectURL = "https://github.com/cenkalti/AI-Writer"
    
    var body: some View {
        Group {
            VStack(alignment: .center) {
                Text("Welcome to AI Writer")
                    .font(.title)
                    .fontWeight(.bold)
            }
            
            VStack(alignment: .leading) {
                Text("Integrate LLM (Large Language Model) capabilities directly into your workflow across any application on macOS.")
                    .fixedSize(horizontal: false, vertical: true)
                
                Text("Setup (required)")
                    .font(.headline)
                    .padding(.top)
                
                Text("Before you get started, make sure you've set your LLM endpoint and model into the settings section of the app.")
                    .fixedSize(horizontal: false, vertical: true)
                
                Text("How It Works")
                    .font(.headline)
                    .padding(.top)
                
                VStack(alignment: .leading) {
                    Text("• Highlight the text you want to change in any application").fixedSize(horizontal: false, vertical: true)
                    Text("• Use the shortcut for text transformation, default is Command-Shift-\\\\").fixedSize(horizontal: false, vertical: true)
                }
                
                Text("Support")
                    .font(.headline)
                    .padding(.top)
                
                HStack(spacing: 3) {
                    Text("Create an issue at")
                    Link(projectURL, destination: URL(string: projectURL)!)
                }
            }
            .padding(.top)
            
            VStack(alignment: .center) {
                Button("Open Settings") {
                    openWindow(id: "settings"); NSApp.activate(ignoringOtherApps: true)
                }
            }
            .padding(.top)
        }
        .padding()
        .frame(minWidth: 500)
    }
}

#Preview {
    HelpView()
}
