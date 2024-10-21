import SwiftUI

struct SettingsView: View {
    
    @AppStorage(Defaults.Keys.prompt.rawValue) var prompt: String = defaultPrompt
    
    @AppStorage(Defaults.Keys.apiKey.rawValue) var apiKey: String = ""
    
    @AppStorage(Defaults.Keys.model.rawValue) var model: String = defaultModel
    
    @AppStorage(Defaults.Keys.baseUrl.rawValue) var baseUrl: String = ""
        
    var body: some View {
        Form {
            Section(header: Text("General").font(.title)) {
                LaunchAtLogin.Toggle("Launch at login")
            }
            Section(header: Text("Keyboard Shortcut").font(.title)) {
                Text("After opening keyboard settings window, click Services, then click on Text. There, you will find the \"Rewrite with AI\" option.").foregroundStyle(.secondary)
                Button("Keyboard Settings") {
                    let url = URL(string: "x-apple.systempreferences:com.apple.preference.keyboard?Shortcuts")!
                    NSWorkspace.shared.open(url)
                }
            }
            Section(header: Text("LLM Settings").font(.title)) {
                TextField("Base URL", text: $baseUrl, prompt: Text(defaultBaseUrl.absoluteString))
                    .textFieldStyle(.roundedBorder)
                Text("Leave empty for default").foregroundStyle(.secondary)
                TextField("Model", text: $model, prompt: Text(defaultModel))
                    .textFieldStyle(.roundedBorder)
                TextField("API Key", text: $apiKey, prompt: Text("sk-xkpf2..."))
                    .textFieldStyle(.roundedBorder)
            }
            Section(header: Text("System Prompt").font(.title)) {
                TextEditor(text: $prompt)
                    .frame(minHeight: 150)
                    .font(.body)
                    .cornerRadius(5)
                Button("Restore Prompt to Default") { prompt = defaultPrompt }
            }
        }
        .padding()
        .frame(minWidth: 600)
    }
}

#Preview {
    SettingsView()
}
