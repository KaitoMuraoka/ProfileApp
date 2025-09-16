import SwiftUI
import QRCode
import CoreGraphics

struct ContentView: View {
    @State private var qrImage: CGImage?
    
    var body: some View {
        VStack(spacing: 16) {
            VStack {
                qrCode
            }
            .padding(.vertical, 1.618*50)
            .padding(.horizontal, 50)
            .background(.white)
            .cornerRadius(8)
            .clipped()
            .shadow(color: .gray.opacity(0.7), radius: 5)
        }
        .padding()
        .task {
            let text = "https://x.com/Ktombow1110"
            if let url = URL(string: "https://avatars.githubusercontent.com/u/70003919?v=4"),
               let logo = await fetchCGImage(from: url) {
                qrImage = setupQRCode(for: text, logoImage: logo)
            } else {
                qrImage = setupQRCode(for: text)
            }
        }
    }

    @ViewBuilder
    private var qrCode: some View {
        if let cg = qrImage {
            Image(decorative: cg, scale: 1.0, orientation: .up)
                .interpolation(.none)
                .antialiased(false)
                .resizable()
                .frame(width: 200, height: 200)
        } else {
            Text("QR を生成中...")
                .foregroundStyle(.secondary)
        }
    }
}

/// QRコード生成
func setupQRCode(for text: String, logoImage: CGImage? = nil) -> CGImage? {
    guard let doc = try? QRCode.Document(utf8String: text) else { return nil }
    doc.design.style.backgroundFractionalCornerRadius = 3.0
    
    if let logoImage {
        doc.logoTemplate = QRCode.LogoTemplate.CircleCenter(image: logoImage)
    }
    
    return try? doc.cgImage(dimension: 400)
}

/// URLからCGImageを非同期取得
func fetchCGImage(from url: URL) async -> CGImage? {
    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        if let uiImage = UIImage(data: data) {
            return uiImage.cgImage
        }
    } catch {
        print("画像取得失敗: \(error)")
    }
    return nil
}

#Preview {
    ContentView()
}
