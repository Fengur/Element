import Cocoa
@testable import Utils
/**
 * NOTE: We query with skin because we need to access element in the metrics method
 */
class StylePropertyParser{
    /**
     * Returns a property from PARAM: skin and PARAM: property
     * NOTE: the reason that depth defaults to 0 is because if the exact depth isnt found there should only be depth 0, if you have more than 1 depth in a property then you must supply at all depths or just the 1 that will work for all depths
     * TODO: ⚠️️ Should probably also support when state is know and depth is defaulted to 0 ?!?!?
     */
    static func value(_ skin:ISkin, _ propertyName:String, _ depth:Int = 0)->Any!{//TODO: <-- Try to remove the ! char here
        return skin.style!.getValue(propertyName,depth)
    }
    /**
     * Returns an IFillStyle instance based on the Style attached to the skin
     */
    static func fillStyle(_ skin:ISkin,_ depth:Int = 0)->IFillStyle {
        let val = value(skin,CSSConstants.fill,depth)
        if let gradient = val as? IGradient {
            return gradientFillStyle(gradient)
        }else{
            return colorFillStyle(val,skin,depth)
        }
    }
    /**
     * Returns an ILineStyle instance based on the Style attached to the skin
     */
    static func lineStyle(_ skin:ISkin, _ depth:Int = 0) -> ILineStyle? {
        let val:Any? = value(skin,CSSConstants.line,depth)
        if let gradient = val as? IGradient {
            return gradientLineStyle(gradient,skin,depth)
        }else{
            return colorLineStyle(val as? NSColor,skin,depth)
        }
    }
    /**
     * Returns an Offset instance
     * TODO: probably upgrade to TRBL
     * NOTE: the way you let the index in the css list decide if something should be included in the final offsetType is probably a bad convention. Im not sure. Just write a note why, if you figure out why its like this.
     */
    static func lineOffsetType(_ skin:ISkin, _ depth:Int = 0) -> OffsetType {
        let val:Any? = value(skin, CSSConstants.lineOffsetType,depth)
        var offsetType:OffsetType = {
            if (val is String) || (val is [String]) {
                return LayoutUtils.instance(val!, OffsetType.self) as! OffsetType
            };return OffsetType()
        }()
        let lineOffsetTypeIndex:Int = StyleParser.index(skin.style!, CSSConstants.lineOffsetType,depth)
        if(StyleParser.index(skin.style!, CSSConstants.lineOffsetTypeLeft,depth) > lineOffsetTypeIndex){ offsetType.left = StylePropertyParser.string(skin, CSSConstants.lineOffsetTypeLeft)}
        if(StyleParser.index(skin.style!, CSSConstants.lineOffsetTypeRight,depth) > lineOffsetTypeIndex){ offsetType.right = StylePropertyParser.string(skin, CSSConstants.lineOffsetTypeRight,depth)}
        if(StyleParser.index(skin.style!, CSSConstants.lineOffsetTypeTop,depth) > lineOffsetTypeIndex){ offsetType.top = StylePropertyParser.string(skin, CSSConstants.lineOffsetTypeTop,depth)}
        if(StyleParser.index(skin.style!, CSSConstants.lineOffsetTypeBottom,depth) > lineOffsetTypeIndex){ offsetType.bottom = StylePropertyParser.string(skin, CSSConstants.lineOffsetTypeBottom,depth)}
        return offsetType
    }
    /**
     * Returns a Fillet instance
     * TODO: probably upgrade to TRBL
     * TODO: needs to return nil aswell. Since we need to test if a fillet doesnt exist. if a fillet has just 0 values it should still be a fillet etc. 
     */
    static func fillet(_ skin:ISkin, _ depth:Int = 0) -> Fillet {
        let val:Any? = value(skin, CSSConstants.cornerRadius,depth)
        let fillet:Fillet = {
            if (val is CGFloat) || (val is [Any]) {
                return LayoutUtils.instance(val!, Fillet.self) as! Fillet
            };return Fillet()
        }()
        let cornerRadiusIndex:Int = StyleParser.index(skin.style!, CSSConstants.cornerRadius, depth);//returns -1 if it doesnt exist
        if(StyleParser.index(skin.style!, CSSConstants.cornerRadiusTopLeft, depth) > cornerRadiusIndex) { fillet.topLeft = StylePropertyParser.number(skin, "corner-radius-top-left", depth) }//TODO: replace this with the constant: cornerRadiusIndex
        if(StyleParser.index(skin.style!, CSSConstants.cornerRadiusTopRight, depth) > cornerRadiusIndex) { fillet.topRight = StylePropertyParser.number(skin, "corner-radius-top-right", depth) }
        if(StyleParser.index(skin.style!, CSSConstants.cornerRadiusBottomLeft, depth) > cornerRadiusIndex) { fillet.bottomLeft = StylePropertyParser.number(skin, "corner-radius-bottom-left", depth) }
        if(StyleParser.index(skin.style!, CSSConstants.cornerRadiusBottomRight, depth) > cornerRadiusIndex) { fillet.bottomRight = StylePropertyParser.number(skin, "corner-radius-bottom-right", depth) }
        return fillet
    }
    
    /**
     * Returns TextFormat
     * TODO: ⚠️️ Make functional 🤖
     */
    private static var metricPattern:String = "^(-?\\d*?\\.?\\d*?)((%|ems)|$)"
    static func textFormat(_ skin:TextSkin)->TextFormat {
        var textFormat:TextFormat = TextFormat()
        for textFormatKey:String in TextFormatConstants.textFormatPropertyNames {
            var value:Any? = StylePropertyParser.value(skin, textFormatKey)
            //if(textFormatKey == "size") print("size: "+value+" "+(value is String))
            if(value != nil) {
                if(StringAsserter.metric("\(value)")){
                    let stringValue:String = "\(value)"
                    let matches = stringValue.matches(metricPattern)
                    matches.forEach { match in
                        var value:Any = match.value(stringValue, 1)/*Capturing group 1*/
                        let suffix:String = match.value(stringValue, 2)/*Capturing group 2*/
                        if(suffix == CSSConstants.ems) {value = "\(value)".cgFloat * CSSConstants.emsFontSize }
                    }
                }
                if(value is [String]) { value = StringModifier.combine(value as! [String], " ") }/*Some fonts are seperated by a space and thus are converted to an array*/
                textFormat[textFormatKey] = value!
            }
        }
        return textFormat
    }
    /**
     * Returns Offset
     * TODO: Merge ver/hor Offset into this one like you did with cornerRadius
     * TODO: Add support for % as it isnt implemented yet, see the margin implementation for guidance
     */
    static func offset(_ skin:ISkin,_ depth:Int = 0)->CGPoint {
        let value:Any? = self.value(skin, CSSConstants.offset, depth)
        if(value == nil){return CGPoint(0,0)}//<---temp solution
        var array:[CGFloat] = value is CGFloat ? [value as! CGFloat] : (value as! [Any]).cast() /*map {String($0).cgFloat}*/ //the map method is cool. But it isnt needed, since this array will always have a count of 2
        return array.count == 1 ? CGPoint(array[0],0) : CGPoint(array[0], array[1])
    }
    /**
     * NOTE: TRBL
     * NOTE: if this method is buggy refer to the legacy code as you changed a couple of method calls : value is now metric
     * TODO: should this have a failsafe if there is no Padding property in the style?
     * TODO: try to figure out a way to do the padding-left right top bottom stuff in the css resolvment not here it looks so cognativly taxing
     * TODO: you may want to copy margin on this
     */
    static func padding(_ skin:ISkin,_ depth:Int = 0) -> Padding {
        var padding:Padding = {
            guard let value = self.value(skin, CSSConstants.padding,depth) else{
                return Padding()
            };return Padding(value)
        }()
        let paddingIndex:Int = StyleParser.index(skin.style!, CSSConstants.padding, depth)
        padding.left = (StyleParser.index(skin.style!, CSSConstants.paddingLeft,depth) > paddingIndex ? StylePropertyParser.metric(skin, CSSConstants.paddingLeft, depth) : Utils.metric(padding.left, skin))!/*if margin-left has a later index than margin then it overrides margin.left*/
        padding.right = (StyleParser.index(skin.style!, CSSConstants.paddingRight,depth) > paddingIndex ? StylePropertyParser.metric(skin, CSSConstants.paddingRight, depth) : Utils.metric(padding.right, skin))!
        padding.top = (StyleParser.index(skin.style!, CSSConstants.paddingTop,depth) > paddingIndex ? StylePropertyParser.metric(skin, CSSConstants.paddingTop, depth) : Utils.metric(padding.top, skin))!
        padding.bottom = ((StyleParser.index(skin.style!, CSSConstants.paddingBottom,depth) > paddingIndex) ? StylePropertyParser.metric(skin, CSSConstants.paddingBottom, depth) : Utils.metric(padding.bottom, skin))!
        return padding
    }
    /**
     * TODO: Should this have a failsafe if there is no Margin property in the style?
     * TODO: Try to figure out a way to do the margin-left right top bottom stuff in the css resolvment not here it looks so cognativly taxing
     */
    static func margin(_ skin:ISkin, _ depth:Int = 0)->Margin {
        var margin:Margin = {
            guard let value = self.value(skin, CSSConstants.margin,depth) else{
                return Margin()
            };return Margin(value)
        }()
        let marginIndex:Int = StyleParser.index(skin.style!, CSSConstants.margin,depth)
        margin.left = (StyleParser.index(skin.style!, CSSConstants.marginLeft,depth) > marginIndex ? metric(skin, CSSConstants.marginLeft,depth) : Utils.metric(margin.left, skin))!/*if margin-left has a later index than margin then it overrides margin.left*/
        margin.right = (StyleParser.index(skin.style!, CSSConstants.marginRight,depth) > marginIndex ? metric(skin, CSSConstants.marginRight,depth) : Utils.metric(margin.right, skin))!
        margin.top = (StyleParser.index(skin.style!, CSSConstants.marginTop,depth) > marginIndex ? metric(skin, CSSConstants.marginTop,depth) : Utils.metric(margin.top, skin))!
        margin.bottom = StyleParser.index(skin.style!, CSSConstants.marginBottom,depth) > marginIndex ? metric(skin, CSSConstants.marginBottom,depth)! : Utils.metric(margin.bottom, skin)!
        return margin
    }
    static func width(_ skin:ISkin, _ depth:Int = 0) -> CGFloat? {
        return metric(skin,CSSConstants.width,depth)
    }
    static func height(_ skin:ISkin, _ depth:Int = 0) -> CGFloat? {
        return metric(skin,CSSConstants.height,depth)
    }
    /**
     * New
     */
    static func rotation(_ skin:ISkin, _ depth:Int = 0) -> CGFloat?{
        if let rotation:CGFloat = value(skin, CSSConstants.transform, depth) as? CGFloat {
            return rotation
        }
        return nil
    }
    /**
     * Returns a Number derived from eigther a percentage value or ems value (20% or 1.125 ems == 18)
     */
    static func metric(_ skin:ISkin,_ propertyName:String, _ depth:Int = 0)->CGFloat? {
        let value = StylePropertyParser.value(skin,propertyName,depth)
        return Utils.metric(value,skin)
    }
    /**
     * Retuns asser url
     */
    static func asset(_ skin:ISkin, _ depth:Int = 0) -> String {
        if let val = value(skin, CSSConstants.fill,depth), let arr = val as? [Any], let str = arr[0] as? String{
            return str
        }
        fatalError("no asset in \(skin) at depth: \(depth)")
    }
    /**
     * TODO: This method is asserted before its used, so you may ommit the optionality
     */
    static func dropShadow(_ skin:ISkin, _ depth:Int = 0)->DropShadow? {
        if let dropShadow:DropShadow = value(skin, CSSConstants.drop_shadow,depth) as? DropShadow {
            return dropShadow
        }
        return nil//dropShadow as? String,  str == CSSConstants.none
    }
}
private class Utils{
    /**
     * TODO: Explain what this method is doing
     */
    static func metric(_ value:Any?,_ skin:ISkin)->CGFloat? {
        if(value is Int){ return CGFloat(value as! Int)}/*<-- int really? shouldnt you use something with decimals?*/
        else if(value is CGFloat){return value as? CGFloat}
        else if(value is String){/*value is String*/
            let pattern:String = "^(-?\\d*?\\.?\\d*?)((%|ems)|$)"//<--this can go into a static class variable since it is used twice in this class
            let stringValue:String = value as! String
            let matches = stringValue.matches(pattern)
            for match:NSTextCheckingResult in matches {
                let valStr:String = match.value(stringValue, 1)/*capturing group 1*/
                let suffix:String = match.value(stringValue, 2)/*capturing group 1*/
                let valNum:CGFloat = valStr.cgFloat
                if(suffix == "%") {
                    let val:CGFloat = valNum / 100 * (skin.element!.getParent() != nil ? (totalWidth(skin.element!.getParent() as! IElement)/*(skin.element.parent as IElement).getWidth()*/) : 0);/*we use the width of the parent if the value is percentage, in accordance to how css works*/
                    //Swift.print("skin.element.parent != null: " + skin.element.parent != null)
                    //Swift.print("(skin.element.parent as IElement).skin: " + (skin.element.parent as IElement).skin)
                    return val
                }else {
                    return valNum * CSSConstants.emsFontSize/*["suffix"] == "ems"*/
                }
            }
        }
        //⚠️️ be warned this method is far from complete
        return nil//<---this should be 0, it will require some reprograming
    }
    /**
     * Returns the total width
     * TODO: Should margin be added to total width? check google for the box model specs (a work around is too add equal amount of margin-right)
     */
    static func totalWidth(_ element:IElement)->CGFloat {/*beta*/
        if(element.skin != nil){
            let margin:Margin = SkinParser.margin(element.skin!)
            let border:Border = SkinParser.border(element.skin!)
            let padding:Padding = SkinParser.padding(element.skin!)
            let width:CGFloat = element.getWidth()/*StylePropertyParser.height(element.skin);*/
            let tot:CGFloat = margin.left + border.left + width - padding.left - padding.right - border.right - margin.right
            return tot/*Note used to be + padding.right + border.right + margin.right*/
        }else {return element.getWidth()}
    }
}
extension StylePropertyParser{
    /*
     * Convenince method for deriving CGFloat values
     */
    static func number(_ skin:ISkin, _ propertyName:String, _ depth:Int = 0)->CGFloat{
        return string(skin, propertyName,depth).cgFloat//was cast like this-> CGFloat(Double()!)
    }
    /**
     * Convenince method for deriving String values
     */
    static func string(_ skin:ISkin, _ propertyName:String, _ depth:Int = 0)->String{
        return "\(value(skin, propertyName,depth))"//swift 3 update
    }
}
//private
extension StylePropertyParser{
    /**
     * Returns a GradientFillStyle
     */
    fileprivate static func gradientFillStyle(_ gradient:IGradient) -> GradientFillStyle {
        return GradientFillStyle(gradient,NSColor.clear)
    }
    /**
     * Returns a GradientLineStyle
     * NOTE: We use line-thickness because the property thickness is occupid by textfield.thickness
     */
    fileprivate static func gradientLineStyle(_ gradient:IGradient, _ skin:ISkin, _ depth:Int = 0) -> GradientLineStyle {
        let lineThickness:CGFloat = value(skin, CSSConstants.lineThickness,depth) as! CGFloat
        return GradientLineStyle(gradient, lineThickness, NSColor.clear)
    }
    /**
     * Returns a LineStyle instance
     * TODO: this is wrong the style property named line-color doesnt exist anymore, its just line now
     * NOTE: we use line-thickness because the property thickness is occupid by textfield.thickness
     */
    fileprivate static func colorLineStyle(_ colorValue:NSColor?, _ skin:ISkin, _ depth:Int = 0) -> ILineStyle {
        let lineThickness:CGFloat = value(skin, CSSConstants.lineThickness,depth) as? CGFloat ?? CGFloat.nan
        let lineAlpha:CGFloat = value(skin, CSSConstants.lineAlpha,depth) as? CGFloat ?? 1
        let nsColor:NSColor = colorValue != nil ? colorValue!.alpha(lineAlpha) : NSColor.clear
        return LineStyle(lineThickness, nsColor)
    }
    /**
     * NOTE: makes sure that if the value is set to "none" or doesnt exsist then NaN is returned (NaN is interpreted as do not draw or apply style)
     */
    fileprivate static func color(_ skin:ISkin, _ propertyName:String, _ depth:Int = 0) -> NSColor? {
        let color:Any? = value(skin, propertyName,depth)
        return color == nil || (color as? String) == CSSConstants.none ? nil : color as? NSColor
    }
    /**
     * Returns a FillStyle instance
     * TODO: add support for the css: fill:none; (the current work-around is to set fill-alpha:0)
     * TODO: ⚠️️ I don't think we need support for array anymore, consider removing it
     */
    fileprivate static func colorFillStyle(_ colorValue:Any?,_ skin:ISkin, _ depth:Int = 0)->IFillStyle {
        var nsColor:NSColor? = colorValue as? NSColor
        if let colorValue = colorValue as? [Any] {
            if let colorVal = colorValue[safe:1]{
                if let colorValStr = colorVal as? String, colorValStr == CSSConstants.none{
                    nsColor = nil
                }else if let colorValNSColor = colorVal as? NSColor{
                    nsColor = colorValNSColor
                }else{
                    fatalError("type not supported, must be nsColor or string that is equal to CSSConstants.none")
                }
            }
        }else{
            fatalError("colorValue not supported: " + "\(colorValue)")
        }
        let alpha:Any? = StylePropertyParser.value(skin,CSSConstants.fillAlpha,depth)
        let alphaValue:CGFloat = alpha as? CGFloat ?? 1
        nsColor = nsColor != nil ? nsColor!.alpha(alphaValue) : NSColor.clear/*<-- if color is NaN, then the color should be set to clear, or should it?, could we instad use nil, but then we would need to assert all fill.color values etc, we could create a custom NSColor class, like NSEmptyColor that extends NSCOlor, since we may want NSColor.clear in the future, like clear the fill color etc? clear is white with alpha 0.0*/
        return FillStyle(nsColor!)
    }
}

//Deprecate

/**
 * NOTE: this is really a modifier method
 * TODO: add support for % (this is the percentage of the inherited font-size value, if none is present i think its 12px)
 */
/*static func textField(_ skin:TextSkin) {
    for textFieldKey:String in TextFieldConstants.textFieldPropertyNames {
        let value:Any? = StylePropertyParser.value(skin,textFieldKey)
        if(value != nil) {
            if(StringAsserter.metric(value as! String)){
                //TODO: You may need to set one of the inner groups to be non-catchable
                let pattern:String = "^(-?\\d*?\\.?\\d*?)((%|ems)|$)"
                let stringValue:String = "\(value)"//swift 3 update
                let matches = stringValue.matches(pattern)
                for match:NSTextCheckingResult in matches {
                    var value:Any = match.value(stringValue,1)/*Capturing group 1*/
                    let suffix:String = match.value(stringValue,2)/*Capturing group 2*/
                    if(suffix == CSSConstants.ems) {value = "\(value)".cgFloat * CSSConstants.emsFontSize }
                }
            }
            //TODO: this needs to be done via subscript probably, see that other code where you used subscripting recently
            fatalError("Not implemented yet")
            //skin.textField[textFieldKey] = value
        }
    }
    fatalError("out of order")
}*/
