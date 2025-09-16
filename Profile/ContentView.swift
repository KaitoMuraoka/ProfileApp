import SwiftUI
import QRCode
import CoreGraphics

struct ContentView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)

            if let cg = setupQRCode(for: "This is Content") {
                // CGImage は非オプショナルで渡す。orientation も指定する
                Image(decorative: cg, scale: 1.0, orientation: .up)
                    .interpolation(.none)    // QR をくっきり表示
                    .antialiased(false)
                    .resizable()
                    .frame(width: 200, height: 200)
            } else {
                Text("QR の生成に失敗しました")
                    .foregroundStyle(.secondary)
            }

            Text("Hello, world!")
        }
        .padding()
    }
}

func setupQRCode(for text: String) -> CGImage? {
    // QRCode.Document(...) と cgImage(...) は throws なので try? で Optional に
    guard
        let doc = try? QRCode.Document(utf8String: text),
        let cgImage = try? doc.cgImage(dimension: 400)
    else {
        return nil
    }
    return cgImage
}

#Preview {
    ContentView()
}
