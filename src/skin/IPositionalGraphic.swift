import Foundation

protocol IPositionalGraphic:IPositionable,IGraphicDecoratable {/*We need the getGraphic() from IGraphicDecoratable*/
    //the IPositionable and IGraphicDecoratable provides the properties needed
}
extension IPositionalGraphic{
    var x:CGFloat{get{return getGraphic().x}set{getGraphic().x = newValue}}
    var y:CGFloat{get{return getGraphic().y}set{getGraphic().y = newValue}}
    /**
     *
     */
    func setPosition(position:CGPoint){
        getGraphic().setPosition(position)
    }
}