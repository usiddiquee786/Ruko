sub ShowGridScreen()
    m.GridScreen = CreateObject("roSGNode", "GridScreen")
    m.GridScreen.observeField("rowlistbutton2", "onButtonSelected")
    ShowScreen(m.GridScreen)'show GridScreen
    
end sub
' sub onButtonSelected(event as Object)
'     m.GridScreen.content=m.contentTask.content
'     ShowScreen(m.GridScreen)
' end sub
sub onButtonSelected(event as Object)
    ShowMarkupGridScreen()
end sub