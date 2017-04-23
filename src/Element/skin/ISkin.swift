import Foundation
@testable import Utils

protocol ISkin:class{
    /*Implicit getters / setters*/
    func setStyle(_ style:IStyle)
    func setSkinState(_ state:String)
    func setSize(_ width:CGFloat, _ height:CGFloat)
    func getWidth()->CGFloat
    func getHeight()->CGFloat
    /*Getters / Setters*/
    var decoratables:Array<IGraphicDecoratable>{get set}
    var style:IStyle?{get set}
    var state:String{get set}
    var element:IElement?{get}/*We use IElement here instead of Element because sometimes we need to use Window which is not an Element but impliments IElement*/
    var width:CGFloat?{get}
    var height:CGFloat?{get}
    var hasStyleChanged:Bool{get}
    var hasStateChanged:Bool{get}
    var hasSizeChanged:Bool{get}
}
