import SwiftUI
import Combine
import QRCode
import CoreGraphics
import SwiftData

@MainActor final class QRCodePresenter: ObservableObject {
    @Published var qrImage: CGImage?
    @Published var qrCodeUrlString: String = ""
    @Published var qrCodeImageUrlString: String = ""
    @Published var showSheet: Bool = false
    
    @Query private var qrCodeModels: [QRCodeModel]
    @Environment(\.modelContext) private var modelContext
}

extension QRCodePresenter {
    func viewDidLoad() {
        Task {
            setup()
            guard !qrCodeUrlString.isEmpty else { return }
            if let url = URL(string: qrCodeImageUrlString) {
                let logo = await fetchCGImage(from: url)
                qrImage = setupQRCode(for: qrCodeUrlString, logoImage: logo)
            } else {
                qrImage = setupQRCode(for: qrCodeUrlString)
            }
        }
    }
    
    func addView() {
        showSheet = true
    }
    
    func saveQRCode() {
        let newModel = QRCodeModel(qrCodeUrlString: qrCodeUrlString, qrCodeImageUrlString: qrCodeImageUrlString)
        modelContext.insert(newModel)
        viewDidLoad()
        showSheet = false
    }
    
    func cancelView() {
        showSheet = false
    }
    
    func openWebView() {
        // TODO: WebView で開く
    }
    
    private func setup() {
        guard let qrCodeModel = qrCodeModels.first else { return }
        self.qrCodeUrlString = qrCodeModel.qrCodeUrlString
        self.qrCodeImageUrlString = qrCodeModel.qrCodeImageUrlString
    }
    
    /// QRコード生成
    private func setupQRCode(for text: String, logoImage: CGImage? = nil) -> CGImage? {
        guard let doc = try? QRCode.Document(utf8String: text) else { return nil }
        doc.design.style.backgroundFractionalCornerRadius = 3.0
        
        if let logoImage {
            doc.logoTemplate = QRCode.LogoTemplate.CircleCenter(image: logoImage)
        }
        
        return try? doc.cgImage(dimension: 400)
    }
    
    /// URLからCGImageを非同期取得
    private func fetchCGImage(from url: URL) async -> CGImage? {
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
}
