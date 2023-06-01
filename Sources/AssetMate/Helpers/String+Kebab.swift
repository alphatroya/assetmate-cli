extension String {
    var kebab: String {
        lowercased().replacingOccurrences(of: " ", with: "-")
    }
}
