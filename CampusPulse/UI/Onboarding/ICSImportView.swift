import SwiftUI
import UniformTypeIdentifiers

struct ICSImportView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var isImporterPresented = false
    @State private var importedCount = 0
    @State private var previews: [BusyBlock] = []

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Button("Import .ics File") { isImporterPresented = true }
                .buttonStyle(.borderedProminent)

            if importedCount > 0 {
                Text("Imported \(importedCount) schedule items.").font(Typography.headline)
            }

            ForEach(previews.prefix(5), id: \.id) { block in
                Text("\(block.title) • \(block.startDate.formatted(date: .abbreviated, time: .shortened))")
            }
        }
        .fileImporter(
            isPresented: $isImporterPresented,
            allowedContentTypes: [UTType(filenameExtension: "ics") ?? .plainText]
        ) { result in
            if case .success(let url) = result,
               let data = try? Data(contentsOf: url),
               let content = String(data: data, encoding: .utf8) {
                let blocks = ICSImportService.parseBusyBlocks(from: content)
                blocks.forEach(modelContext.insert)
                importedCount = blocks.count
                previews = blocks
                try? modelContext.save()
            }
        }
    }
}
