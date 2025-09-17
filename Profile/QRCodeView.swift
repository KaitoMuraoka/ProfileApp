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
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button { presenter.addView() } label: {
                    Image(systemName: "info")
                }
            }
        }
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
    NavigationStack { // NavigationStack で包むと Toolbar が有効に出る
        QRCodeView(presenter: .init())
    }
}
