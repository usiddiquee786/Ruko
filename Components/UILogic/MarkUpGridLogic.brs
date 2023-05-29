sub ShowMarkupGridScreen()
    ' create new instance of details screen
    m.markup = CreateObject("roSGNode", "MarkUp")
    ' m.posterGrid.content=m.contentTask.content 
    m.markup.observeField("rowlistbutton", "onButtonSelected2")
    ShowScreen(m.markup)
end sub
sub onButtonSelected2(event as Object)
    RunContentTask()
    ShowRowListScreen()
end sub