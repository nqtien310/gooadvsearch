$ ->
    $("#add-new-query-btn").click ->
        appendNextRowContent(".search_query")

    $("#add-new-website-btn").click ->
        appendNextRowContent(".website")

appendNextRowContent = (rowType) ->
    $rows = $(rowType)
    index = $rows.size() - 1
    nextIndex = $rows.size()
    
    content = nextRow($rows[index].outerHTML, index, nextIndex)
    $rows.last().after content


nextRow = (content, currentRowIndex, nextRowIndex) ->
    replaceToken = "[" + nextRowIndex + "]"
    regex = new RegExp("\\[" + currentRowIndex + "\\]","g")
    content = content.replace(regex, replaceToken)

    replaceToken = "_" + nextRowIndex + "_"
    regex = new RegExp("_" + currentRowIndex + "_","g")        
    content = content.replace(regex, replaceToken)

    content
    