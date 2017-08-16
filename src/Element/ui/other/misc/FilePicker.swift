import Cocoa
@testable import Utils
/**
 * When you need to browse for files or urls
 * NOTE: this is a Composition of other UI components
 * TODO: ⚠️️ Add some event logic to this class, and modal popup
 */
class FilePicker:Element{
    lazy var textInput:TextInput = .init(self.getWidth(),self.getHeight(),initData.text,initData.input,self)
    lazy var button:TextButton = .init(self.getWidth(), self.getHeight(), initData.buttonText, self)
    private let initData:(text:String,input:String,buttonText:String)
    init(text: String, input: String, buttonText: String, size:CGSize = CGSize(NaN,NaN), parent:ElementKind? = nil, id:String? = nil) {
        initData = (text,input,buttonText)
        super.init(size.width, size.height, parent, id)
    }
    override func resolveSkin() {
        super.resolveSkin()
        addSubview(textInput)
        addSubview(button)
    }
    override func onEvent(_ event: Event) {
        if event.assert(.upInside) {
            onBrowseButtonClick()
        }
    }
    required init(coder: NSCoder) {fatalError("init(coder:) has not been implemented") }
}
extension FilePicker{
    func onBrowseButtonClick(){
        //Swift.print("onBrowseButtonClick")
        let dialog:NSOpenPanel = NSOpenPanel()//prompt the file viewer
        dialog.canCreateDirectories = true
        dialog.title = "Select path"
        dialog.canChooseDirectories = true
        dialog.canChooseFiles = true
        dialog.directoryURL = {
            let dirURLStr:String = textInput.inputText
            return dirURLStr.tildePath.url
        }()
        let respons = dialog.runModal()
        if let url = dialog.url,respons == NSApplication.ModalResponse.OK{
            textInput.setInputText(url.path.tildify)
        }
    }
}
