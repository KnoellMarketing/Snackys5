{block name='boxes-box-filter-manufacturer'}
    {if $nSeitenTyp === $smarty.const.PAGE_ARTIKELLISTE}
        <section id="sidebox{$oBox->getID()}" class="box box-filter-manufacturer panel small">
            <div class="h5 panel-heading dpflex-a-c">
                {lang key='manufacturers'}
                {if ($snackyConfig.filterOpen == 1 && $oBox->position == 'left') || ($oBox->position == 'bottom' && $snackyConfig.footerBoxesOpen === '0')}<span class="caret"></span>{/if}
            </div>
            {block name='boxes-box-filter-manufacturer-include-manufacturer'}
            <div class="panel-body">
                {include file='snippets/filter/manufacturer.tpl' filter=$oBox->getItems()}
            </div>
            {/block}
        </section>
    {/if}
{/block}
