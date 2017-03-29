import Cocoa
@testable import Utils

protocol ScrollableFast:IFastList, Scrollable{}
extension ScrollableFast{
    /**
     * New
     * TODO: you could also override scroll and hock after the forward scroll call and then retrive the progress from the var. less code, but the value must be written in Displaceview, it could mess up Elastic, because it needs different progress. etc, do later
     */
    func onScrollWheelChange(_ event:NSEvent) {//⚠️️ It could be that we would need to use progress rather than progressVal, might be annomalies between these
        Swift.print("📜🐎 ScrollableFast.onScrollWheelChange: \(event)")
        let progressVal:CGFloat = SliderListUtils.progress(event.delta[dir], interval, progress)
        Swift.print("progressVal: " + "\(progressVal)")
        Swift.print("progress: " + "\(progress)")
        /**/
        let val:CGFloat = ScrollableUtils.scrollTo(progressVal, maskSize[dir], contentSize[dir])
        Swift.print("val: " + "\(val)")
        contentContainer!.point[dir] = val
        /**/
        (self as IFastList).setProgress(progressVal)//update the reuse algo
        
        
        let progressVal:CGFloat = SliderListUtils.progress(event.delta[dir], interval, slider!.progress)//TODO: Should we really store the progress value here?
        slider!.setProgressValue(progressVal)
        (self as SlidableScrollable).setProgress(progressVal)//move the lableContainer
        (self as IFastList).setProgress(progressVal)//update the reuse algo
        
        
    }
    func onInDirectScrollWheelChange(_ event:NSEvent) {//enables momentum
        onScrollWheelChange(event)
    }
}

