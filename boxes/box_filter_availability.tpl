{block name='boxes-box-filter-availability'}
    {if $nSeitenTyp === $smarty.const.PAGE_ARTIKELLISTE}
        <section id="sidebox{$oBox->getID()}" class="box box-filter-availability panel">
            <div class="h5 panel-heading dpflex-a-c">
                {lang key='filterAvailability'}
                {if ($snackyConfig.filterOpen == 1 && $oBox->position == 'left') || ($oBox->position == 'bottom' && $snackyConfig.footerBoxesOpen === '0')}<span class="caret"></span>{/if}
            </div>
            {block name='boxes-box-filter-availability-content'}
            <div class="panel-body">
                {include file='snippets/filter/genericFilterItem.tpl' filter=$oBox->getItems()}
            </div>
            {/block}
        </section>
    {/if}
{/block}
