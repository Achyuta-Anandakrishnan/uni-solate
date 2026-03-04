import Foundation

struct ICSImportService {
    private static let formats = ["yyyyMMdd'T'HHmmss'Z'", "yyyyMMdd'T'HHmmss", "yyyyMMdd"]

    static func parseBusyBlocks(from content: String) -> [BusyBlock] {
        let lines = content.components(separatedBy: .newlines)
        var blocks: [BusyBlock] = []
        var inside = false
        var summary: String?
        var start: Date?
        var end: Date?

        for line in lines {
            if line == "BEGIN:VEVENT" {
                inside = true
                summary = nil; start = nil; end = nil
                continue
            }
            if line == "END:VEVENT" {
                if inside, let title = summary, let start, let end {
                    blocks.append(BusyBlock(title: title, startDate: start, endDate: end, source: "ICS"))
                }
                inside = false
                continue
            }
            guard inside else { continue }
            if line.hasPrefix("SUMMARY") {
                summary = line.components(separatedBy: ":").dropFirst().joined(separator: ":")
            } else if line.hasPrefix("DTSTART") {
                start = parseDate(value: line)
            } else if line.hasPrefix("DTEND") {
                end = parseDate(value: line)
            }
        }
        return blocks
    }

    private static func parseDate(value: String) -> Date? {
        guard let raw = value.components(separatedBy: ":").last else { return nil }
        for format in formats {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = format
            if format.contains("Z") { formatter.timeZone = TimeZone(secondsFromGMT: 0) }
            if let date = formatter.date(from: raw) { return date }
        }
        return nil
    }
}
