{block name='boxes-box-search-cloud'}
    {block name='boxes-box-search-cloud-script'}
        {inline_script}<script>
            $(window).on('load', function () {
                var searchItems     = {json_encode($oBox->getItems())},
                    searchcloudTags = [];

                $.each(searchItems, function (key, value) {
                    searchcloudTags.push({
                        text:   value.cSuche,
                        weight: value.nAnzahlGesuche,
                        link:   '{$ShopURL}/?qs=' + value.cSuche
                    });
                });

                $('#sidebox{$oBox->getID()} .searchcloud').jQCloud(searchcloudTags, {
                    autoResize: true,
                    steps:      7
                });
            });
        </script>{/inline_script}
    {/block}
    {card class="box box-searchcloud box-normal" id="sidebox{$oBox->getID()}"}
        {block name='boxes-box-search-cloud-content'}
            {block name='boxes-box-search-cloud-title'}
                <div class="productlist-filter-headline">
                    {lang key='searchcloud'}
                </div>
            {/block}
            <div class="searchcloud"></div>
        {/block}
    {/card}
{/block}
