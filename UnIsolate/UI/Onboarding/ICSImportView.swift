import SwiftUI
import UniformTypeIdentifiers

struct ICSImportView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var isImporterPresented = false
    @State private var importedCount = 0
    @State private var previews: [BusyBlock] = []

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Import Schedule (.ics)")
                .font(Typography.title)
            Text("Upload your class/work schedule to improve schedule-fit recommendations.")
                .foregroundStyle(.secondary)

            Button {
                isImporterPresented = true
            } label: {
                Label("Import .ics File", systemImage: "square.and.arrow.down")
            }
            .buttonStyle(.borderedProminent)

            if importedCount > 0 {
                Label("Imported \(importedCount) schedule items.", systemImage: "checkmark.circle.fill")
                    .foregroundStyle(.green)
            }

            if !previews.isEmpty {
                Text("Preview")
                    .font(Typography.headline)
                ForEach(previews.prefix(5), id: \.id) { block in
                    CPCard {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(block.title).font(Typography.headline)
                            Text(block.startDate.formatted(date: .abbreviated, time: .shortened))
                                .font(Typography.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }

            Spacer()
        }
        .fileImporter(
            isPresented: $isImporterPresented,
            allowedContentTypes: [UTType(filenameExtension: "ics") ?? .plainText]
        ) { result in
            guard case .success(let url) = result,
                  let data = try? Data(contentsOf: url),
                  let content = String(data: data, encoding: .utf8)
            else { return }

            let blocks = ICSImportService.parseBusyBlocks(from: content)
            blocks.forEach(modelContext.insert)
            importedCount = blocks.count
            previews = blocks
            try? modelContext.save()
        }
    }
}
