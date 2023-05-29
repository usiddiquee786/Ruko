sub onContentSet() 'invoked when item metadata retrived
    content =m.top.itemContent
    'set poster uri if content is valid
    if content <> invalid
        ?"content.hdPosterUrl " content.hdPosterUrl
        m.top.FindNode("poster").uri=content.hdPosterUrl
    end if
end sub