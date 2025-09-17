import SwiftUI
import QRCode
import CoreGraphics

struct ContentView: View {
    var body: some View {
        NavigationStack {
            QRCodeView(presenter: .init())
        }
    }
}

#Preview {
    ContentView()
}
