import Cocoa
@testable import Utils
/**
 * TODO: For the sake of optiomization, TextSkin should not extend Skin, but rather extend NSText. Less views means better speed
 * TODO: Probably disable ineteractivity when using TextSkin ?
 * TODO: Add support for disabling interactivty via css: mouseEnabled:true; or alike
 * TODO: Add support for leading via css like: leading:2px;<--This requires some research effort as an atempt to solve this before yielded nothing (2-3H research): This has the answer but its very complicated to setup: http://stackoverflow.com/questions/11182735/nstextfield-add-line-spacing
 */
class TextSkin:Skin,ITextSkin{
    var textField:TextField
    /*the bellow variable is a little more complex in the legacy code*/
    //the bellow line was update to swift 3, may break things
    override var width:CGFloat? {get{return textField.frame.size.width} set{textField.frame.size.width = newValue!}}// :TODO: make a similar funciton for getHeight, based on needed space for the height of the textfield
    var hasTextChanged:Bool = true/*<-Why is is this true by default?*/
    init(_ style:IStyle, _ text:String, _ state:String = SkinStates.none, _ element:IElement? = nil){
        textField = TextField(frame: NSRect())
        //textField.sizeToFit()
        textField.stringValue = text
        super.init(style, state, element)
        addSubview(textField)
        applyProperties(textField)
        SkinModifier.float(self)
        _ = SkinModifier.align(self, textField)
        textField.isHidden = SkinParser.display(self) == CSSConstants.none
    }
    override func draw() {
        if (hasStyleChanged || hasSizeChanged || hasStateChanged || hasTextChanged) {
            SkinModifier.float(self)
            if(hasSizeChanged) {
                let padding:Padding = StylePropertyParser.padding(self);
                TextFieldModifier.size(textField, width! + padding.left + padding.right, height! + padding.top + padding.bottom)
            }
            if(hasStateChanged || hasStyleChanged || hasTextChanged) {applyProperties(textField)}
            if(hasTextChanged) {hasTextChanged = false}
            _ = SkinModifier.align(self, textField)
        }
        super.draw()
    }
    /**
     * // :TODO: Make a similar funciton for getHeight, based on needed space for the height of the textfield
     */
    override func getWidth() -> CGFloat {
        if((StylePropertyParser.value(self, TextFormatConstants.wordWrap.rawValue) == nil)){/*if the wordWrap is false the the width of the skin is equal to the width of the textfield (based on needed space for the text)*/
            let padding:Padding = StylePropertyParser.padding(self)
            return textField.frame.size.width + padding.left + padding.right//swift 3 update happened
        }else {return super.getWidth()}
    }
    required init(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
}
extension TextSkin{
    /**
     * Set the text and updates the skin
     * TODO: Add more advance setText features like start and end etc
     */
    func setText(_ text:String){
        textField.stringValue = text
        hasTextChanged = true
        draw()//<---this must be uncommented, it was commented just for a test to be completed. Very imp. Debug the problem with it. its probaly simple, Now its uncommented again!
    }
    func applyProperties(_ textField:TextField){
        let padding:Padding = StylePropertyParser.padding(self)
        let width:CGFloat = (StylePropertyParser.width(self) ?? super.width!) + padding.left + padding.right// :TODO: only querry this if the size has changed?
        let height:CGFloat = (StylePropertyParser.height(self) ?? super.height!) + padding.top + padding.bottom// :TODO: only querry this if the size has changed?
        textField.frame.w = width/*SkinParser.width(this)*/
        textField.frame.h = height/*SkinParser.height(this)*/
        super.frame.w = width//quick fix
        super.frame.h = height//quick fix
        let textFormat:TextFormat = StylePropertyParser.textFormat(self)/*creates the textFormat*/
        TextFieldModifier.applyTextFormat(textField,textFormat)/*applies the textFormat*/
        /*
         let temp = textField.stringValue/*<--temp fix until you find a way to refresh TextField*/
         textField.stringValue = " "
         textField.stringValue = temp
         */
        let temp = textFormat.attributedStringValue(textField.stringValue)
        //textField.stringValue = " "
        textField.attributedStringValue = temp
    }
}
