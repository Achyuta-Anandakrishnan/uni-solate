import SwiftUI

struct SchoolEmailView: View {
    @Binding var school: String
    @Binding var email: String

    private var isValidEduEmail: Bool {
        email.contains("@") && email.lowercased().hasSuffix(".edu")
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Select your school")
                .font(Typography.title)

            Picker("School", selection: $school) {
                Text("NC State").tag("NC State")
                Text("UNC").tag("UNC")
                Text("Duke").tag("Duke")
            }
            .pickerStyle(.segmented)

            VStack(alignment: .leading, spacing: 8) {
                Text("School email")
                    .font(Typography.headline)
                TextField("name@school.edu", text: $email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .padding()
                    .background(ColorTokens.surface)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                Label(isValidEduEmail ? "Email looks good" : "Please enter a .edu email", systemImage: isValidEduEmail ? "checkmark.seal.fill" : "exclamationmark.triangle")
                    .font(Typography.caption)
                    .foregroundStyle(isValidEduEmail ? .green : .orange)
            }

            Spacer()
        }
        .padding()
    }
}
