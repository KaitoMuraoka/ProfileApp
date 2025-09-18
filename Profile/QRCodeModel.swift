import SwiftData

@Model
final class QRCodeModel {
    var qrCodeUrlString: String
    var qrCodeImageUrlString: String
    
    init(qrCodeUrlString: String, qrCodeImageUrlString: String) {
        self.qrCodeUrlString = qrCodeUrlString
        self.qrCodeImageUrlString = qrCodeImageUrlString
    }
}
