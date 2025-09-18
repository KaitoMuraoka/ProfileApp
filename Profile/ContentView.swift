import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        NavigationStack {
            QRCodeView(presenter: .init())
                .modelContainer(for: QRCodeModel.self)
        }
    }
}

#Preview {
    ContentView()
}
