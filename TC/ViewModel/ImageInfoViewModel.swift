//
//  ImageInfoViewModel.swift
//  TC
//
//  Created by Oleg Granchenko on 22.04.2021.
//

import SwiftUI

final class ImageInfoViewModel: ObservableObject {
    @Published var images: [ImageInfo] = []
    
    func fillImageInfo() {
        for idx in 1...12 {
            images.append(ImageInfo(id: UUID(),
                                    image: "photo\(idx)"))
        }
    }
    
    func getBlackPixelsAndSort(_ resizedImage: UIImage,
                               with index: Range<Array<ImageInfo>.Index>.Element? = nil,
                               at loopIndex: Int? = nil) {
        DispatchQueue.global(qos: .userInteractive).async { [unowned self] in
            blackPixelsPercent(in: resizedImage) { value in
                DispatchQueue.main.async {
                    if let idx = index {
                        self.changeImageInfo(value, for: idx)
                    } else {
                        self.changeImageInfo(value, at: loopIndex)
                    }
                    
                    self.sortImages()
                }
            }
        }
    }
    
    private func changeImageInfo(_ blackPixelsPercent: CGFloat,
                                 for index: Range<Array<ImageInfo>.Index>.Element? = nil,
                                 at loopIndex: Int? = nil) {
        self.images[(index ?? loopIndex)!].blackPixelsPercent = blackPixelsPercent
    }
    
    private func sortImages() {
        withAnimation {
            self.images.sort { $0.blackPixelsPercent ?? 0 > $1.blackPixelsPercent ?? 0 }
        }
    }
    
    func showPercent(_ valuePercent: CGFloat?) -> some View {
        guard let value = valuePercent else {
            return Text("")
        }
        switch value {
        case let value where value > 0.0:
            return Text(" Label with \(value)% black ")
        case let value where value == 0.0:
            return Text(" COMPLETELY WHITE ")
        default:
            return Text(" Wrong result! ")
        }
    }
    
    func resizeBegin(with image: UIImage,
                     width: Int,
                     height: Int) -> UIImage {
        return image.resizedImage(for: CGSize(width: width,
                                              height: height))!
    }
    
    private func ocupaedArreacPercent(overal : CGFloat, detected : CGFloat) -> CGFloat {
        return detected / overal * 100
    }
    
    func blackPixelsPercent(in image: UIImage, completion: (CGFloat) -> Void) {
        let imageBlackCount = image.blackPixelCount
        let imagePixelSum = image.size.width * image.size.height
        let detectedPercent = ocupaedArreacPercent(overal : imagePixelSum, detected : CGFloat(imageBlackCount))
        completion(detectedPercent)
    }
    
    func resizeImagesBeginAndSort() {
        for (idx, value) in images.enumerated() {
            getBlackPixelsAndSort(resizeBegin(with: UIImage(named: value.image)!,
                                              width: 30,
                                              height: 30),
                                  at: idx)
        }
    }
    
    func isHideLoaderForEachImage(_ set: Bool) {
        images.enumerated().forEach { idx, val in
            images[idx].isHideLoader = set
        }
    }
}
