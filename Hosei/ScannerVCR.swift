import SwiftUI
import VisionKit

struct
ScannerVCR: UIViewControllerRepresentable {

	private let
	completionHandler: ( VNDocumentCameraScan? ) -> Void
	 
	init( completion: @escaping ( VNDocumentCameraScan? ) -> Void ) {
		self.completionHandler = completion
	}

	final class
	Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {

		private let
		VCR: ScannerVCR
		 
		init( _ VCR: ScannerVCR ) { self.VCR = VCR }
		 
		@objc func
		didFinishSavingImage(
		_								: UIImage
		,	didFinishSavingWithError	: NSError!
		,	contextInfo					: UnsafeMutableRawPointer
		) {
		}

		func
		documentCameraViewController(
		_							: VNDocumentCameraViewController
		,	didFinishWith	scan	: VNDocumentCameraScan
		) {
			for i in 0 ..< scan.pageCount {
				UIImageWriteToSavedPhotosAlbum(
					scan.imageOfPage( at: i )
				,	self
				,	#selector(self.didFinishSavingImage(_:didFinishSavingWithError:contextInfo:))
				,	nil
				)
			}
			VCR.completionHandler( scan )
		}
	}
	func
	makeCoordinator() -> Coordinator {
		Coordinator( self )
	}
	 
	func
	makeUIViewController(
		context	: UIViewControllerRepresentableContext<ScannerVCR>
	) -> VNDocumentCameraViewController {
		let VC = VNDocumentCameraViewController()
		VC.delegate = context.coordinator
		return VC
	}
	 
	func
	updateUIViewController(
	_			: VNDocumentCameraViewController
	,	context	: UIViewControllerRepresentableContext<ScannerVCR>
	) {
	}
}

