import Foundation
@testable import Utils
/**
 * NOTE: to force the CheckButton to apply its Checked or unchecked skin, use the setChecked after the instance is created
 * NOTE: isChecked is not priv because setting it manually and then setting style is cheaper than using setSkinState. TreeList uses this scheme
 */
class CheckButton:Button,ICheckable{
    var isChecked:Bool
    init(_ width:CGFloat, _ height:CGFloat, _ isChecked:Bool = false, _ parent:IElement? = nil, _ id:String? = nil){
        self.isChecked = isChecked
        super.init(width,height,parent,id);
    }
    override func mouseUpInside(_ event:MouseEvent) {
        isChecked = !isChecked
        super.mouseUpInside(event)
        super.onEvent(CheckEvent(CheckEvent.check, isChecked, self))
    }
    /**
     * Sets the self.isChecked variable (Toggles between two states)
     */
    func setChecked(_ isChecked:Bool) {
        self.isChecked = isChecked
        setSkinState(getSkinState())
    }
    /*override func setSkinState(_ state:String) {
     Swift.print("CheckButton.setSkinState()")
     super.setSkinState(state)
     }*/
    func getChecked() -> Bool {
       return isChecked
    }
    override func getSkinState() -> String {
        return isChecked ? SkinStates.checked + " " + super.getSkinState() : super.getSkinState()
    }
    required init(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
}
