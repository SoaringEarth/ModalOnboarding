import SwiftUI
import PhotosUI

struct ProfileImage: View {
	let imageState: ImageState
	
	var body: some View {
		switch imageState {
		case .success(let image):
			image.resizable()
		case .loading:
			ProgressView()
		case .empty:
			Image(systemName: "person.fill")
				.font(.system(size: 40))
				.foregroundColor(.white)
		case .failure:
			Image(systemName: "exclamationmark.triangle.fill")
				.font(.system(size: 40))
				.foregroundColor(.white)
		}
	}
}

struct CircularProfileImage: View {
	let imageState: ImageState
	
	var body: some View {
		ProfileImage(imageState: imageState)
            .scaledToFill()
			.clipShape(Circle())
			.frame(width: 120, height: 120)
			.background {
				Circle().fill(
					LinearGradient(
                        colors: [.orange, .orange.opacity(0.2)],
						startPoint: .topLeading,
						endPoint: .bottomTrailing
					)
				)
			}
	}
}

struct EditableCircularProfileImage: View {
	@ObservedObject var viewModel: RegistrationInputViewModel
	
	var body: some View {
		CircularProfileImage(imageState: viewModel.imageState)
			.overlay(alignment: .bottomTrailing) {
				PhotosPicker(selection: $viewModel.imageSelection,
							 matching: .images,
							 photoLibrary: .shared()) {
					Image(systemName: "pencil.circle.fill")
						.symbolRenderingMode(.multicolor)
						.font(.system(size: 44))
						.foregroundColor(.accentColor)
				}
				.buttonStyle(.borderless)
			}
	}
}
