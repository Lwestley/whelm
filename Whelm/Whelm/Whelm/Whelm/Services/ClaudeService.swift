import Foundation

class ClaudeService {
    static let shared = ClaudeService()
    private let apiURL = "https://api.anthropic.com/v1/messages"
    private let model = "claude-sonnet-4-20250514"

    private var apiKey: String {
        guard let key = Bundle.main.infoDictionary?["ANTHROPIC_API_KEY"] as? String else {
            fatalError("Missing ANTHROPIC_API_KEY in Info.plist")
        }
        return key
    }

    func ask(
        starterName: String,
        day: Int,
        observations: [String],
        notes: String = ""
    ) async throws -> String {
        let observationText = observations.joined(separator: ", ")
        let notesText = notes.isEmpty ? "" : " Additional notes: \(notes)."

        let prompt = """
        You are Whelm, a master sourdough baker companion app. You speak with calm authority, warmth, and precision. You never overwhelm — you give exactly what the baker needs to know right now.

        The user has a sourdough starter named \(starterName) on day \(day) of 14.

        Today's observations: \(observationText).\(notesText)

        Respond with:
        1. What these observations mean in 2-3 sentences. Be specific to what they described.
        2. Exactly what they should do today in 2-3 clear action points.

        Keep the total response under 150 words. No bullet points — use natural flowing language. Speak directly to them, not about them.
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

        let (data, _) = try await URLSession.shared.data(for: request)

        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let content = json["content"] as? [[String: Any]],
              let first = content.first,
              let text = first["text"] as? String else {
            throw URLError(.badServerResponse)
        }

        return text
    }
}
