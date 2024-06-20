//
//  UIImage+Extension.swift
//  GeekReport
//
//  Created by sookim on 4/8/24.
//

import UIKit

extension UIImage {
    // 클로저방식으로 처리 적용 - WWDC18에서 권장하는 방법
    func resizeImageWithRenderer(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale

        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { context in
            self.draw(in: CGRect(origin: .zero, size: size))
        }

        return renderImage
    }
}
