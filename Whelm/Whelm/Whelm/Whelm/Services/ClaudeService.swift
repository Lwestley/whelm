import Foundation

class ClaudeService {
    static let shared = ClaudeService()
    private let apiURL = "https://api.anthropic.com/v1/messages"
    private let model = "claude-sonnet-4-5"
    
    private var apiKey: String {
        guard let key = Bundle.main.infoDictionary?["ANTHROPIC_API_KEY"] as? String,
              !key.isEmpty else {
            return ""
        }
        return key
    }

    func ask(
        starterName: String,
        day: Int,
        observations: [String],
        notes: String = "",
        flourType: String = "Bread flour",
        kitchenTemp: Double = 72.0,
        units: String = "Imperial"
    ) async throws -> String {
        let observationText = observations.joined(separator: ", ")
        let notesText = notes.isEmpty ? "" : " Additional notes: \(notes)."

        let tempString = units == "Imperial" ? "\(Int(kitchenTemp))°F" : "\(Int(kitchenTemp))°C"

        let prompt = """
        You are Whelm, a master sourdough baker companion app. You speak with calm authority, warmth, and precision. You never overwhelm — you give exactly what the baker needs to know right now.

        The user has a sourdough starter named \(starterName) on day \(day) of 14.
        Their kitchen is \(tempString) and they are using \(flourType).

        Today's observations: \(observationText).\(notesText)

        Respond in two paragraphs with a blank line between them. No headers, no bullet points, no bold text, no asterisks, no em dashes. Just clean flowing prose.

        First paragraph: what these observations mean. Be specific to what they described. Factor in their kitchen temperature and flour type where relevant.
        Second paragraph: exactly what they should do today. Be direct and clear.

        Keep the total response under 150 words. Speak directly to them, not about them.
        """

        let body: [String: Any] = [
            "model": model,
            "max_tokens": 300,
            "messages": [
                ["role": "user", "content": prompt]
            ]
        ]

        var request = URLRequest(url: URL(string: apiURL)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let content = json["content"] as? [[String: Any]],
              let first = content.first,
              let text = first["text"] as? String else {
            throw URLError(.badServerResponse)
        }

        return text
    }
}
