import SwiftUI

struct SettingsView: View {
    
    @AppStorage(Defaults.Keys.prompt.rawValue) var prompt: String = defaultPrompt
    
    @AppStorage(Defaults.Keys.apiKey.rawValue) var apiKey: String = ""
    
    @AppStorage(Defaults.Keys.model.rawValue) var model: String = defaultModel
    
    @AppStorage(Defaults.Keys.baseUrl.rawValue) var baseUrl: String = ""
    
    let apiKeysURL = "https://platform.openai.com/api-keys"
    
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
            Section(header: Text("OpenAI Settings").font(.title)) {
                TextField("API Key", text: $apiKey, prompt: Text("sk-xkpf2..."))
                    .textFieldStyle(.roundedBorder)
                HStack {
                    Text("Get one from:").foregroundStyle(.secondary)
                    Link(apiKeysURL, destination: URL(string: apiKeysURL)!)
                }
                TextField("Base URL", text: $baseUrl, prompt: Text(defaultBaseUrl.absoluteString))
                    .textFieldStyle(.roundedBorder)
                Text("Leave empty for default").foregroundStyle(.secondary)
                Picker("Model", selection: $model) {
                    ForEach(models, id: \.self) { model in
                        Text(model).tag(model)
                    }
                }
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
