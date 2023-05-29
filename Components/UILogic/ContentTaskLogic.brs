sub RunContentTask()
    m.contentTask = CreateObject("roSGNode","MainLoaderTask")
    
    ' observe content so we can know when feed content will parsed
    m.contentTask.ObserveField("content","OnMainContentLoaded")
    m.contentTask.control ="run" 'GetContent(see MainloaderTask.brs) 'method is executed
    m.loadingIndicator.visible=true 'show loading indicator while content is loading
    ?"content task =" m.contentTask
end sub

sub OnMainContentLoaded() 'invoke when content is ready to be used 
    m.GridScreen.SetFocus(true)'set focus to Grid Screen
    m.loadingIndicator.visible=false 'hide the loading indicator because the content retrieved 
    m.GridScreen.content=m.contentTask.content 'populate GridScreen with content
end sub


