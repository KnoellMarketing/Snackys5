!function() {
    "use strict";
    !$.snackyList && ($.snackyList = {});
    var e = function() {};
    e.prototype = {
        data: {
            isLoading: !1,
            endlessObserver: {}
        },
        constructor: e,
        load: function() {
			if($("body").attr('data-page') == 2 && $('div.endless-scrolling').length)
			{
				$(".pagination-ajax").closest(".row").hide(),
				this.activePrev(),
				this.activeNext(),
				this.watchEndless()
			}
        },
        panelOpener: function() {},
        closePanels: function() {},
        rewatchEndless: function() {
            $.snackyList.data.endlessObserver.disconnect(),
            $.snackyList.addToObserver()
        },
        watchEndless: function() {
            this.data.endlessObserver = new IntersectionObserver(function(e, t) {
                if (0 == $.snackyList.data.isLoading)
                    for (var a = 0; a < e.length; a++)
                        if (e[a].isIntersecting)
                            if ("view-next" == e[a].target.id) {
                                $.snackyList.data.isLoading = !0;
                                var i = $("#view-next").attr("data-url");
                                "" != i && "false" != i ? ($("#view-next").parent().addClass("loading"),
                                $.snackyList.loadArticles(i)) : $("#view-next").remove()
                            } else
                                "pagination-url" == e[a].target.className ? window.history.replaceState("endless", window.title, e[a].target.getAttribute("data-url")) : console.log("observer something crazy?")
            }
            ,{
                rootMargin: "0px 0px 50px 0px",
                threshold: 0
            }),
            this.addToObserver()
        },
        addToObserver: function() {
            var e = document.getElementById("view-next");
            e && $.snackyList.data.endlessObserver.observe(e);
            var t = document.getElementsByClassName("pagination-url");
            if (t)
                for (var a = 0; a < t.length; a++)
                    $.snackyList.data.endlessObserver.observe(t[a])
        },
        loadArticles: function(e, t) {
            var a = e, url, html;
            e && "" != e && $.ajax({
                type: "POST",
                url: e,
                data: {
                    isAjax: 1,
                    paging: 1 == t ? "prev" : "next"
                },
                cache: !1
            }).done(function(e) {
				html = $(e);
				url = $('#endless-url',html).html();
				if(url) url = url.replaceAll('&amp;', '&');
                1 == t ? ($("#view-prev").attr("data-url", $.trim(url)),
                $("#view-prev").parent().after('<span class="pagination-url" data-url="' + a + '"></span>' + $('#p-l',html).html()))
				: 
				($("#view-next").attr("data-url", $.trim(url)),
                $("#view-next").parent().before('<span class="pagination-url" data-url="' + a + '"></span>' + $('#p-l',html).html()));
				
                $.snackyList.activePrev(),
                $.snackyList.activeNext(),
                $.snackyList.data.isLoading = !1,
                $(".endless-scrolling.loading").removeClass("loading"),
                //sImages && sImages.rewatch(),
                $.snackyList.rewatchEndless(),
                "function" == typeof $.evo.article && ($.evo.article().onLoad(),
                $.evo.article().register(),
                addValidationListener()),
                $("#p-l .exp a, #p-l a.img-w").off("click").on("click", function(e) {
                    window.history.replaceState("endless", window.title, window.location.href + "#" + $(this).closest(".p-c").attr("id"))
                })
            }).fail(function(e) {
                console.log("error while loading articles")
            })
        },
        activePrev: function() {
            var e = $("#view-prev").attr("data-url");
            "" != e && "false" != e || $("#view-prev").parent().remove(),
            $("#view-prev").off("click"),
            $("#view-prev").on("click", function() {
                var e = $(this).attr("data-url");
                "" != e && "false" != e ? ($(this).parent().addClass("loading"),
                $.snackyList.loadArticles(e, !0)) : $(this).parent().remove()
            })
        },
        activeNext: function() {
            var e = $("#view-next").attr("data-url");
            "" != e && "false" != e || $("#view-next").parent().remove(),
            $("#view-next").off("click"),
            $("#view-next").on("click", function() {
                var e = $(this).attr("data-url");
                "" != e && "false" != e ? ($(this).parent().addClass("loading"),
                $.snackyList.loadArticles(e)) : $(this).parent().remove()
            })
        },
        loadNextArticles: function() {
            var e = $("#view-next").parent()[0];
            if (e && 0 == $.snackyList.data.isLoading) {
                var t = e.getBoundingClientRect();
                if (t.top >= 0 && t.top <= $(window).height()) {
                    $.snackyList.data.isLoading = !0;
                    var a = $("#view-next").attr("data-url");
                    "" != a && "false" != a ? ($("#view-next").parent().addClass("loading"),
                    $.snackyList.loadArticles(a)) : $("#view-next").remove()
                }
            }
        }
    },
    $.snackyList = new e,
    $.snackyList.load()
}(jQuery);
