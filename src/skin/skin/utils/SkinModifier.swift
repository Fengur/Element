import Cocoa
/**
 * // :TODO: Make the methods more Element cetric less skin centric
 */
class SkinModifier {
    /**
     * Aligns @param view
     */
    class func align(skin:ISkin, _ positional:IPositional,_ depth:Int = 0)->IPositional {
        //Swift.print("SkinModifier.align() positional: " + "\(positional)")
        //var offset:CGPoint = StylePropertyParser.offset(skin,depth);
        //var padding:Padding2 = StylePropertyParser.padding(skin,depth);
        let margin:Margin = StylePropertyParser.margin(skin,depth);
        //var floatType:String = SkinParser.float(skin,depth);
        //if(floatType == CSSConstants.LEFT || floatType == "" || floatType == null) DisplayObjectModifier.position(displayObject, new Point(margin.left + offset.x, margin.top + offset.y));
        //else if(floatType == CSSConstants.RIGHT) DisplayObjectModifier.position(displayObject, new Point(padding.right + margin.right + offset.x, margin.top + padding.top + offset.y));
        //else /*floatType == CSSConstants.NONE*/
        
        positional.setPosition(CGPoint(margin.left/* + offset.x*/, margin.top/* + offset.y*/))// :TODO: this is temp for testing
        return positional
    }
    /**
     * Floats @param skin
     * @Note if clear == "none" no clearing is performed
     * @Note if float == "none" no floating is performed
     * // :TODO: Text instances are inline, button are block (impliment inline and block stuff)
     * // :TODO: Impliment support for box-sizing?!?
     * // :TODO: Add support for hiding the element if its float is none
     * // :TODO: possibly merge floatLeft and clearLeft? and floatRight and clearRight? or have float left/right call the clear calls
     */
    class func float(skin:Skin){// :TODO: rename since it floats and clears which are two methods, position? // :TODO: move to ElementModifier
        
        if(skin.element!.getParent() is IElement == false) {return}/*if the skin.element doesnt have a parent that is IElement skip the code bellow*/// :TODO: this should be done by the caller
        let parent:NSView = skin.element!.getParent(/*true*/) as! NSView/**/
        //Swift.print("parent: " + parent);
        let elementParent:IElement = skin.element!.getParent() as! IElement/**/
        //Swift.print("elementParent: " + elementParent);
        let elements:Array<IElement> = ElementParser.children(parent,IElement.self)
        
        let index:Int = parent.contains(skin.element as! NSView) ? Utils.elementIndex(parent, skin.element!) : elements.count/*The index of skin, This creates the correct index even if its not added to the parent yet*/
        let parentTopLeft:CGPoint = SkinParser.relativePosition(elementParent.skin!);/*the top-left-corner of the parent*/
        //			if(skin is TextSkin) trace("topLeft: " + topLeft);
        let parentTopRight:CGPoint = CGPoint(parentTopLeft.x + SkinParser.totalWidth(elementParent.skin!)/*the top-right-corner of the parent*//*was skin.getHeight()*//* - SkinParser.padding(parent.skin).right - SkinParser.margin(parent.skin).right<-these 2 values are beta*/,parentTopLeft.y);
        //let leftSiblingSkin:Skin = Utils.leftFloatingElementSkin(elements, index);/*the last left floating element-sibling skin*/
        
    }
}
private class Utils{
    /**
     *
     */
    class func elementIndex(parent:NSView,_ element:IElement)->Int {
        return parent.subviews.indexOf(element as! NSView)!
    }
    
    /**
     *
     */
    class func leftFloatingElementSkin(elements:Array<IElement>,index:Int)->Skin {
        var lastIndexOfLeftFloatingElement:Int = Utils.lastIndex(elements, Range(0,index-1), CSSConstants.left);
        return lastIndexOfLeftFloatingElement != -1 ? (elements[lastIndexOfLeftFloatingElement] as IElement).skin : nil;/*the left element-sibling*/
    }
    
    //continue here: add range and the lastIndex method
    
}