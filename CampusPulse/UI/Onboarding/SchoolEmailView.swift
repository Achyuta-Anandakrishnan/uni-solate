import SwiftUI

struct SchoolEmailView: View {
    @Binding var school: String
    @Binding var email: String

    var body: some View {
        Form {
            Picker("School", selection: $school) {
                Text("NC State").tag("NC State")
                Text("UNC").tag("UNC")
                Text("Duke").tag("Duke")
            }
            TextField("name@school.edu", text: $email)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
        }
        .scrollContentBackground(.hidden)
    }
}
