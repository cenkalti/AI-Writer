import Cocoa
import SwiftUI
import AppKit

let defaultBaseUrl = URL(string: "http://localhost:11434")!

let defaultModel = "llama3.2"

let defaultPrompt = """
# Instructions for the Assistant

## Role
You are a helpful assistant who improves users' text.

## Assessment
If the text is already simple and easy to understand, do not rewrite it.

## Improvements:
- Correct any spelling or grammar mistakes.
- Use short sentences.
- Focus on one idea per sentence.
- Use the subject-verb-object structure for clarity.
- Choose simple language and avoid unnecessary, complex, or uncommon words and phrases.

## Tone
Maintain a casual tone.

## Response
Only respond with the revised text. Do not add any quotes to your reply.

## Special Instructions
If there's an instruction in the <instruction> format at the end of the input, follow it, using context from the previous input. Do not include the original instruction in your reply.
"""

class ChatGPT {
    
    static public func makeRequest(_ input: String) throws -> URLRequest {
        print("input: \(input)")
        
        let prompt = try Defaults.getPrompt()
        print("prompt: \(prompt)")
        
        let baseUrl = try Defaults.getBaseUrl()
        print("baseUrl: \(baseUrl.absoluteString)")
        
        let model = try Defaults.getModel()
        print("model: \(model)")
        
        let apiKey = try Defaults.getApiKey()
        
        let query = Query(
            model: model,
            messages: [
                .init(role: "system", content: prompt),
                .init(role: "user", content: input),
            ]
        )
        
        var request = URLRequest(url: baseUrl.appending(path: "/v1/chat/completions"))
        request.timeoutInterval = TimeInterval(29) // Text service timeout is 30 seconds
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(query)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if !apiKey.isEmpty { request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization") }
        
        return request
    }
    
    static public func parse(_ line: String) throws -> String {
        // Chunks are sent as Server Sent Events
        let components = line.split(separator: ":", maxSplits: 1)
        guard components.count == 2, components[0] == "data" else { return "" }
        
        let message = components[1].trimmingCharacters(in: .whitespacesAndNewlines)
        guard message != "[DONE]" else { return "" }
        
        let chunk = try JSONDecoder().decode(Chunk.self, from: Data(message.utf8))
        return chunk.choices.first?.delta.content ?? ""
    }
    
    struct Query: Encodable {
        let stream = true
        let model: String
        let messages: [Message]
    }
    
    struct Message: Encodable {
        let role: String
        let content: String
    }
    
    struct Chunk: Decodable {
        let choices: [Choice]
    }
    
    struct Choice: Decodable {
        let delta: Delta
    }
    
    struct Delta: Decodable {
        let role: String?
        let content: String?
    }
    
}
