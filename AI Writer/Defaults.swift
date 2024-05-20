import Foundation

class Defaults {
    
    enum Keys: String {
        case prompt
        case baseUrl
        case model
        case apiKey
        case behavior
    }
    
    static public func getPrompt() throws -> String {
        guard let promptStr = UserDefaults.standard.string(forKey: Keys.prompt.rawValue) else {
            return defaultPrompt
        }
        let prompt = promptStr.trimmingCharacters(in: .whitespacesAndNewlines)
        if prompt.isEmpty {
            throw AppError.runtimeError("Empty prompt. Please enter the prompt in the settings window.")
        }
        return prompt
    }
    
    static public func getBaseUrl() throws -> URL {
        guard let baseUrlStr = UserDefaults.standard.string(forKey: Keys.baseUrl.rawValue) else {
            return defaultBaseUrl
        }
        if baseUrlStr == "" {
            return defaultBaseUrl
        }
        guard let url = URL(string: baseUrlStr) else {
            throw AppError.runtimeError("invalid \(Keys.baseUrl.rawValue)")
        }
        return url
    }
    
    static public func getModel() throws -> String {
        guard let modelStr = UserDefaults.standard.string(forKey: Keys.model.rawValue) else {
            return defaultModel
        }
        if modelStr == "" {
            return defaultModel
        }
        return modelStr
    }
    
    static public func getApiKey() throws -> String {
        guard let apiKeyStr = UserDefaults.standard.string(forKey: Keys.apiKey.rawValue) else {
            throw AppError.runtimeError("empty \(Keys.apiKey.rawValue)")
        }
        let apiKey = apiKeyStr.trimmingCharacters(in: .whitespacesAndNewlines)
        if apiKey.isEmpty {
            throw AppError.runtimeError("Empty OpenAI API key. Please enter the key in the settings window.")
        }
        return apiKey
    }
}
