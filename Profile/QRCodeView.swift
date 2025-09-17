import SwiftUI
import Combine

struct QRCodeView: View {
    @ObservedObject var presenter: QRCodePresenter
    
    var body: some View {
        VStack(spacing: 16) {
                qrCode
        }
        .padding(.vertical, 1.618*50)
        .padding(.horizontal, 50)
        .background(.white)
        .cornerRadius(8)
        .clipped()
        .shadow(color: .gray.opacity(0.7), radius: 5)
        .onAppear { presenter.viewDidLoad() }
    }
    
    @ViewBuilder
    private var qrCode: some View {
        if let cg = presenter.qrImage {
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

#Preview {
    QRCodeView(presenter: .init())
}
