{block name='productdetails-rating'}
{if $stars > 0}
{assign var=filename1 value='rate'}
{assign var=filename3 value='.png'}
{if isset($total) && $total > 1}
{lang key='averageProductRating' section='product rating' assign='ratingLabelText'}
{else}
{lang key='productRating' section='product rating' assign='ratingLabelText'}
{/if}
{block name="productdetails-rating-main"}
<div class="rating dpflex-a-center dpflex-wrap" title="{$ratingLabelText}: {$stars}/5">
    {strip}
    <div class="img-ct icon op1">
        <svg><use xlink:href="{$ShopURL}/{if empty($parentTemplateDir)}{$currentTemplateDir}{else}{$parentTemplateDir}{/if}img/icons/icons.svg?v={$nTemplateVersion}#icon-star-full"></use></svg>
    </div>
    <div class="img-ct icon op1">
        <svg><use xlink:href="{$ShopURL}/{if empty($parentTemplateDir)}{$currentTemplateDir}{else}{$parentTemplateDir}{/if}img/icons/icons.svg?v={$nTemplateVersion}#icon-star{if $stars >= 2}-full{elseif $stars > 1}-half{/if}"></use></svg>
    </div>
    <div class="img-ct icon op1">
        <svg><use xlink:href="{$ShopURL}/{if empty($parentTemplateDir)}{$currentTemplateDir}{else}{$parentTemplateDir}{/if}img/icons/icons.svg?v={$nTemplateVersion}#icon-star{if $stars >= 3}-full{elseif $stars > 2}-half{/if}"></use></svg>
    </div>
    <div class="img-ct icon op1">
        <svg><use xlink:href="{$ShopURL}/{if empty($parentTemplateDir)}{$currentTemplateDir}{else}{$parentTemplateDir}{/if}img/icons/icons.svg?v={$nTemplateVersion}#icon-star{if $stars >= 4}-full{elseif $stars > 3}-half{/if}"></use></svg>
    </div>
    <div class="img-ct icon op1">
        <svg><use xlink:href="{$ShopURL}/{if empty($parentTemplateDir)}{$currentTemplateDir}{else}{$parentTemplateDir}{/if}img/icons/icons.svg?v={$nTemplateVersion}#icon-star{if $stars >= 5}-full{elseif $stars > 4}-half{/if}"></use></svg>
    </div>
    {/strip}
    {if $nSeitenTyp === $smarty.const.PAGE_ARTIKEL && !empty($total)}<small>({$total})</small>{/if}
</div>
{/block}
{/if}
{/block}