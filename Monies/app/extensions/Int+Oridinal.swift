extension Int {
    var ordinalizedString: String {
        switch self {
        case 11: return "11th"
        case 12: return "12th"
        case 13: return "13th"
        default:
            switch self % 10 {
            case 1: return "\(self)st"
            case 2: return "\(self)nd"
            case 3: return "\(self)rd"
            default:
                return "\(self)th"
            }
        }
    }
}