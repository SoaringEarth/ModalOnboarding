//
//  RegistrationInputViewModel.swift
//  MultiPageForm
//
//  Created by Jonathon Albert on 20/10/2022.
//

import SwiftUI
import PhotosUI

class RegistrationInputViewModel: ObservableObject {

    enum TransferError: Error {
        case importFailed
    }

    struct TransferableProfileImage: Transferable {
        let image: Image

        static var transferRepresentation: some TransferRepresentation {
            DataRepresentation(importedContentType: .image) { data in
                guard let uiImage = UIImage(data: data) else {
                    throw TransferError.importFailed
                }
                let image = Image(uiImage: uiImage)
                return TransferableProfileImage(image: image)
            }
        }
    }

    @Published private(set) var imageState: ImageState = .empty

    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            if let imageSelection {
                let progress = loadTransferable(from: imageSelection)
                imageState = .loading(progress)
            } else {
                imageState = .empty
            }
        }
    }

    private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        return imageSelection.loadTransferable(type: TransferableProfileImage.self) { result in
            DispatchQueue.main.async {
                guard imageSelection == self.imageSelection else {
                    print("Failed to get the selected item.")
                    return
                }
                switch result {
                case .success(let profileImage?):
                    self.imageState = .success(profileImage.image)
                case .success(nil):
                    self.imageState = .empty
                    self.imageSelection = nil
                case .failure(let error):
                    self.imageState = .failure(error)
                    self.imageSelection = nil
                }
            }
        }
    }
}
