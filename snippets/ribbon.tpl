{block name='snippets-ribbon'}
    {if !empty($Artikel->Preise->Sonderpreis_aktiv)}
        {$sale = $Artikel->Preise->discountPercentage}
    {/if}

    {block name='snippets-ribbon-main'}
        {if $Artikel->oSuchspecialBild->getType() == 'Sonderangebote' && $snackyConfig.saleprozent == 'Y'}
            {assign var="rabatt" value=($Artikel->Preise->alterVKNetto-$Artikel->Preise->fVKNetto)/$Artikel->Preise->alterVKNetto*100}
            <span class="ov-t {$Artikel->oSuchspecialBild->getType()|lower|strip:''}">- {$rabatt|round:0}%</span>
        {else}
            <span class="ov-t
                ov-t-{$Artikel->oSuchspecialBild->getType()}">
                {block name='snippets-ribbon-content'}
                    {lang key='ribbon-'|cat:$Artikel->oSuchspecialBild->getType() section='productOverview' printf=$sale|default:''|cat:'%'}
                {/block}
            </span>
        {/if}
    {/block}
{/block}
