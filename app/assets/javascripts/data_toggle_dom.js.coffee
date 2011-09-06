$(document).ready ->
  $("[data-toggle-dom]").each ->
    dom = $($(this).data("toggle-dom"))
    $(this).click -> dom.slideToggle()