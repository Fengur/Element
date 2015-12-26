import Cocoa



class GradientFillStyle:FillStyle,IGradientFillStyle{
    var gradient:Gradient/*IGradient*/;//TODO:change to IGradient
    init(_ gradient:Gradient/*IGradient*/, _ color:NSColor){
        self.gradient = gradient;
        super.init(color);
    }
}
extension IGradientFillStyle{
    func copy() -> IGradientFillStyle {
        return GradientFillStyle(self.gradient,(self as! IFillStyle).color)
    }
}