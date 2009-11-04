$(function() {
    $('#series-dropdown').change(function() {
        var obj = $(".series[data-series='"+$(this).val()+"']")
        obj.addClass('visible').removeClass('hidden')
    })
    $("a").click(function() {
        alert('click')
        var id = $(this).attr('id')
        playMedia(id)
    })
    alert($("a").length)
})

function playMedia(id) {
    alert(id)
    $.get("/play/"+id)
}