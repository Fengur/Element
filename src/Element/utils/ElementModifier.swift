import Cocoa

class ElementModifier {
    /**
     * Changes the visibility of PARAM: element by PARAM: isVisible
     */
    static func hide(_ element:IElement,_ isVisible:Bool) {
        let display:String = isVisible ? "" : CSSConstants.none.rawValue//defines the dispaly param to be set
        applyStyleProperty(element, "display", display)
    }
    /**
     * TODO: what if the state changes? then the StyleManager is queried again and the current display state won't work, a fix would be add the same style to the StyleManger, if you need granularity then add the custom style to a id that only matches the case etc.
     * TODO: Also make a method that uses the actualy StyleProperty class
     */
    static func applyStyleProperty(_ element:IElement,_ key:String,_ value:Any){
        element.skin!.setStyle(StyleModifier.clone(element.skin!.style!))/*This is a temp fix, an unique reference must be applied to every skin*/
        if var styleProperty:IStyleProperty = element.skin!.style!.getStyleProperty(key) {
            styleProperty.value = value/*prop already exists just add value*/
        }else{
            element.skin!.style!.addStyleProperty(StyleProperty(key, value))/*prop doesnt exist add StyleProp to style*/
        }
        element.skin!.setStyle(element.skin!.style!)/*Apply the altered style*/
    }
    static func hideAll(_ elements:[IElement],_ exception:IElement) {
        elements.forEach{ElementModifier.hide($0, ($0 === exception))}
    }
    static func hideChildren(_ view:NSView,_ exception:IElement) {
        hideAll(ElementParser.children(view,IElement.self), exception)
    }
    /**
     * IMPORTANT: ⚠️️ Refreshing the skin also calls StyleResolver.resolve which is an expensive call. because it have to parse through StyleManger for the correct Style
     * NOTE: Sometimes its better to use element.setSkin(element.getSkin()) 
     */
    static func refreshSkin(_ element:IElement){
        ElementModifier.refresh(element, Utils.setSkinState)
    }
    /**
     * IMPORTANT: ⚠️️ Refreshing style is cheaper than calling refresh skin
     */
    static func refreshStyle(_ element:IElement){
        ElementModifier.refresh(element, Utils.setStyle)
    }
    /**
     * Refreshes many elements in PARAM: displayObjectContainer
     * // :TODO: skin should have a dedicated redraw method or a simple workaround
     * NOTE: keep in mind that this can be Window
     */
    private static func refresh(_ element:IElement, _ method: (IElement)->Void = Utils.setStyle) {//<--setStyle is the default param method
        guard let display:String = element.skin!.style!.getStyleProperty("display") as? String, display == CSSConstants.none.rawValue else{return}/*Skip refreshing*/
        method(element)/*apply the method*/
        guard let container:NSView = element as? NSView else{//element is Window ? Window(element).view : element as NSView;
            fatalError("element is not NSView")
        }
        container.subviews.forEach{
            if let child = $0 as? IElement{
                refresh(child,method)/*<--this line makes it recursive*/
            }
        }
    }
    /**
     * Resizes many elements in PARAM: view
     * TODO: ⚠️️ Rename to Resize, its less ambigiouse
     */
    static func size(_ view:NSView,_ size:CGPoint) {
        view.subviews.lazy.flatMap{ view in
            return view as? IElement
            }.forEach{ element in
                 element.setSize(size.x, size.y)
        }
    }
    /**
     * NOTE: refloats PARAM: view children that are of type IElement
     * NOTE: i.e: after hideing of an element, or changing the depth order etc
     */
    static func floatChildren(_ view:NSView) {
        view.subviews.lazy.flatMap{$0 as? IElement}.forEach{float($0)}
    }
    /**
     * New
     */
    static func float(_ element:IElement){
        if let skin = element.skin { SkinModifier.float(skin) }
    }
}
private class Utils{
    static func setStyle(_ element:IElement){
        element.skin!.setStyle(element.skin!.style!)/*Uses the setStyle since its faster than setSkin*/
    }
    /**
     * This operated directly on the skin before as the element.setSkinState may be removed in the future
     */
    static func setSkinState(_ element:IElement){
        element.skin!.setSkinState(element.skin!.state)/*<-- was SkinStates.none but re-applying the same skinState is a better option*/
    }
}
