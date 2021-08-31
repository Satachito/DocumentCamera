import SwiftUI
import VisionKit

struct
ContentView	: View {

	@State private var
	showScannerSheet	= false

	@State private var
	scan				: VNDocumentCameraScan?

	struct
	IDedImage: Identifiable {
	    var id		= UUID()
	    var image	: UIImage
	}

	var
	scanedImages: [ IDedImage ] {
		get {
			var v = [ IDedImage ]()
			for i in 0 ..< ( scan == nil ? 0 : scan!.pageCount ) {
				v.append( IDedImage( image: scan!.imageOfPage( at: i ) ) )
			}
			return v
		}
	}
	var
	body: some View {
		NavigationView {
			VStack {
				Text( scan != nil ? "Saved images:" : "No scans yet" )
				ScrollView {
					LazyVGrid( columns: [ GridItem( .adaptive( minimum: 100 ) ) ] ) {
						ForEach( scanedImages ) { IDed in
							Image( uiImage: IDed.image ).resizable().frame( width:100, height: 100 )
						}
					}
				}
			}.navigationTitle( "Images" ).navigationBarItems(
				trailing: Button(
					action	: { self.showScannerSheet = true }
				,	label	: { Image( systemName: "camera" ).font( .title ) }
				).sheet(
					isPresented: $showScannerSheet
				,	content	: {
						ScannerVCR(
							completion: { scan in
								self.showScannerSheet = false
								if scan != nil { self.scan = scan! }
							}
						)
					}
				)
			)
		}
	}
}

struct
ContentView_Previews: PreviewProvider {
	static var
	previews: some View {
		ContentView()
	}
}
