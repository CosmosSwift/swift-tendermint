public struct ErrorWrapper: Error, Codable {
   public let code: Int
    public let message: String
    public let data: String

    public init(code: Int = -1, message: String = "Unknown", data: String = "Can't deserialize error.") {
        self.code = code
        self.message = message
        self.data = data
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.code = (try? container.decode(Int.self, forKey: .code)) ?? -1
        self.message = (try? container.decode(String.self, forKey: .message)) ?? "Unknown"
        self.data = (try? container.decode(String.self, forKey: .data)) ?? "Not able to decode"
    }
    
    public init(error: Error) {
        self.code = -1
        self.message = "Error created from `Error`"
        self.data = "\(error.localizedDescription)"
    }
}
