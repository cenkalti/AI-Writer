import AppKit

enum AppError: Error {
    case runtimeError(String)
}

func showError(_ text: String, title: String) {
    let alert = NSAlert()
    alert.messageText = title
    alert.informativeText = text
    alert.alertStyle = .critical
    alert.addButton(withTitle: "OK")
    alert.runModal()
}
