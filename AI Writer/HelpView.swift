import SwiftUI

struct HelpView: View {
    
    @Environment(\.openWindow) var openWindow
    
    var body: some View {
        Group {
            VStack(alignment: .center) {
                Text("Welcome to AI Writer")
                    .font(.title)
                    .fontWeight(.bold)
            }
            
            VStack(alignment: .leading) {
                Text("Your gateway to integrating ChatGPT's capabilities directly into your workflow across any application on macOS.")
                    .fixedSize(horizontal: false, vertical: true)
                
                Text("Get Started")
                    .font(.headline)
                    .padding(.top)
                
                Text("Before you get started, make sure you've added your OpenAI API key into the settings section of the app.")
                    .fixedSize(horizontal: false, vertical: true)
                
                Text("How It Works")
                    .font(.headline)
                    .padding(.top)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("• Highlight the text you want to change in any application").fixedSize(horizontal: false, vertical: true)
                    Text("• Use the shortcut for text transformation, default is Command-Shift-\\\\").fixedSize(horizontal: false, vertical: true)
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
