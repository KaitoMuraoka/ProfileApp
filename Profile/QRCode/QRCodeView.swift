import SwiftUI
import Combine
import SwiftData

struct QRCodeView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var presenter = QRCodePresenter()

    var body: some View {
        VStack(spacing: 16) {
            qrCode
                .contextMenu {
                    Button(action: {presenter.openWebView()}) {
                        Text("Webで開く")
                    }
                }
        }
        .padding(.vertical, 1.618*50)
        .padding(.horizontal, 50)
        .background() // TOOD: DarkMode対応
        .cornerRadius(8)
        .clipped()
        .shadow(color: .gray.opacity(0.7), radius: 5)
        .task { presenter.viewDidLoad(context: context) }
        .toolbar {
            ToolbarItem {
                Button { presenter.addView() } label: {
                    Image(systemName: "info")
                }
            }
        }
        .sheet(isPresented: $presenter.showSheet) {
            NavigationStack {
                List {
                    TextField("QRコードのURL", text: $presenter.qrCodeUrlString)
                    TextField("QRコードに表示する画像のURL", text: $presenter.qrCodeImageUrlString)
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(role: .confirm, action: { presenter.saveQRCode(context: context) })
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        Button(role: .cancel, action: { presenter.cancelView() })
                    }
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
        QRCodeView()
            .modelContainer(for: QRCodeModel.self, inMemory: true)
    }
}
