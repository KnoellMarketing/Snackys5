{if $isMobile && $oBox->position == 'left'}
{else}
{block name='boxes-box-new-in-stock'}
    {lang key='newProducts' assign='slidertitle'}
    {assign var=moreLink value=$oBox->getURL()}
    {lang key='showAllNewProducts' assign='moreTitle'}
    {block name='boxes-box-new-in-stock-include-product-slider'}
        {include file='snippets/product_slider.tpl'
            id="boxslider-newproducts-{$oBox->getID()}"
            productlist=$oBox->getProducts()->elemente
            title=$slidertitle
            tplscope='box'
            moreLink=$moreLink
            moreTitle=$moreTitle
        }
    {/block}
{/block}
{/if}