//
//  UIImage.swift
//  FaceDedectionAppUI
//
//  Created by ilhan serhan ipek on 21.09.2023.
//

import Foundation
import SwiftUI
import Vision

extension UIImage {

  func dedectFaces(completion: @escaping ([
  VNFaceObservation]?) -> Void) {
    guard let image = self.cgImage else {
      return completion(nil)
    }

    let request = VNDetectFaceRectanglesRequest()

    let handler = VNImageRequestHandler(cgImage: image)

    try? handler.perform([request])

    guard let observations = request.results as? [VNFaceObservation] else { return completion(nil)}

    completion(observations)
  }

}
