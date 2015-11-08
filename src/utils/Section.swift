import Foundation
class Section:Element {//Unlike Container, section can have a style applied
    init(_ width:Int = 100, _ height:Int = 100, parent:IElement? = nil) {
        super.init(width,height,parent)
    }
    /*
     * Required by super class 
     * TODO: could we add it thorugh extions instead?
     */
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}