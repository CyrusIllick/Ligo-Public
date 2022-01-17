//
//  QRCodeView.swift
//  Ligo
//
//  Created by Cyrus Illick on 7/5/20.
//  Copyright © 2020 Ligo. All rights reserved.
//

import Foundation
import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRCodeView: View {
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    var url: String
    
    var body: some View {
        Image(uiImage: generateQRCode(url)).interpolation(.none).resizable().frame(width: 150, height: 150, alignment: .center
        )
    }
    func generateQRCode(_ url : String) -> UIImage{
        let data = Data(url.utf8)
        filter.setValue(data, forKey: "inputMessage")
        
        if let qrCodeImage = filter.outputImage{
            if let qrCodeCGIImage = context.createCGImage(qrCodeImage, from: qrCodeImage.extent) {
                return UIImage(cgImage: qrCodeCGIImage)
            }
            else {
                return UIImage(systemName: "xmark") ?? UIImage()
            }
        } else {
            return UIImage(systemName: "xmark") ?? UIImage()
        }
    }

}

struct QRCodeView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
