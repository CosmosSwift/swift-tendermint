public struct ErrorWrapper: Error, Codable {
   public let code: Int
    public let message: String
    public let error: String

    public init(code: Int = -1, message: String = "Unknown", error: String = "Can't deserialize error.") {
        self.code = code
        self.message = message
        self.error = error
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.code = (try? container.decode(Int.self, forKey: .code)) ?? -1
        self.message = (try? container.decode(String.self, forKey: .message)) ?? "Unknown"
        self.error = (try? container.decode(String.self, forKey: .error)) ?? "Not able to decode"
    }
}
