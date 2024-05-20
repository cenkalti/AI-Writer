import SwiftUI
import os.log

struct ChatView: View {
    
    let log = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "ChatView")
        
    let input: String?
    
    @State var output = ""
    
    @State var loading = true
    
    @ObservedObject var viewModel: ChatViewModel = ChatViewModel()
    
    let bottomID = UUID()
    
    let debouncer = Debouncer(delay: 0.5)
    
    var body: some View {
        VStack {
            Text("Rewriting with AI...")
                .font(.title)
            Group {
                if loading {
                    ProgressView()
                } else {
                    ScrollView {
                        ScrollViewReader { scrollView in
                            Text(output)
                                .onChange(of: output) { _ in
                                    debouncer.debounce {
                                        withAnimation {
                                            scrollView.scrollTo(bottomID, anchor: .bottom)
                                        }
                                    }
                                }
                            Spacer().id(bottomID)
                        }
                    }
                    .scrollIndicators(.automatic)
                    .disabled(true)
                }
            }
            .frame(width: 300, height: 200)
            Button("Cancel") {
                NSApp.stopModal()
            }
        }
        .padding(25)
        .task {
            guard let input = input else { return }
            do {
                let request = try ChatGPT.makeRequest(input)
                let (stream, response) = try await URLSession.shared.bytes(for: request)
                if let httpResponse = response as? HTTPURLResponse {
                    print("response status code: \(httpResponse.statusCode)")
                    if httpResponse.statusCode >= 400 {
                        throw AppError.runtimeError("API returned HTTP status: \(httpResponse.statusCode)")
                    }
                }
                for try await line in stream.lines {
                    loading = false
                    let chunk = try ChatGPT.parse(line)
                    print("received chunk: \(chunk)")
                    output += chunk
                }
                viewModel.result = .success(output)
            } catch {
                os_log("%@", log: log, type: .error, error.localizedDescription)
                viewModel.result = .failure(error)
            }
            NSApp.stopModal()
        }
        .task {
            do {
                print("sleeping for timeout")
                try await Task.sleep(nanoseconds: 29 * 1_000_000_000) // 29 seconds
                print("sleep done")
                viewModel.result = .success(output + " <timeout>")
                NSApp.stopModal()
            } catch {
                return
            }
        }
        .onExitCommand(perform: {
            NSApp.stopModal()
        })
        .background(BlurView().ignoresSafeArea())
    }
}

class ChatViewModel: ObservableObject {
    @Published var result: Result<String, Error>!
}

class Debouncer {
    
    private let delay: TimeInterval
    private var hasWork = false
    
    init(delay: TimeInterval) {
        self.delay = delay
    }
    
    func debounce(action: @escaping () -> Void) {
        if hasWork {
            return
        }
        hasWork = true
        let workItem = DispatchWorkItem(block: {
            action()
            self.hasWork = false
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: workItem)
    }
}

struct BlurView: NSViewRepresentable {

    func makeNSView(context: Context) -> NSVisualEffectView {
        let effectView = NSVisualEffectView()
        effectView.state = .active
        return effectView
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
    }
}

#Preview {
    ChatView(input: nil)
}
