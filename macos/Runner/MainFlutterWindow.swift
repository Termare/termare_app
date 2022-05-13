import Cocoa
import FlutterMacOS
import flutter_acrylic

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let windowFrame = self.frame
    let blurryContainerViewController = BlurryContainerViewController()
    self.contentViewController = blurryContainerViewController
    self.setFrame(windowFrame, display: true)

    /* Initialize the flutter_acrylic plugin */
    MainFlutterWindowManipulator.start(mainFlutterWindow: self)

    RegisterGeneratedPlugins(registry: blurryContainerViewController.flutterViewController)
    super.awakeFromNib()
  }
}
