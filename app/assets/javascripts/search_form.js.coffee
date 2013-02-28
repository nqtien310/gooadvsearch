$ ->
  $("#add-new-query-btn").click ->
    $queries = $(".search_query")
    queryIndex = $queries.size() - 1
    nextQueryIndex = $queries.size()
    queryContent = $queries[queryIndex].outerHTML
    regexp = new RegExp("\\[" + queryIndex + "\\]", "g")
    queryContent = queryContent.replace(regexp, "[" + nextQueryIndex + "]")
    regexp = new RegExp("_" + queryIndex + "_", "g")
    queryContent = queryContent.replace(regexp, "_" + nextQueryIndex + "_")
    $queries.last().after queryContent

