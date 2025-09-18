import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        NavigationStack {
            QRCodeView()
                .modelContainer(for: QRCodeModel.self)
        }
    }
}

#Preview {
    ContentView()
}
