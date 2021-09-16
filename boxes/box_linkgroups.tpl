{if $snackyConfig.filterOpen == 1 && empty($oBox->getTitle()) && $oBox->position == 'left'}
{else}
{block name='boxes-box-linkgroups'}
    <section class="box box-linkgroup box-normal panel small" id="box{$oBox->getID()}">
        {block name='boxes-box-linkgroups-title'}
            <div class="h5 panel-heading dpflex-a-c">
                {$oBox->getTitle()}
                {if ($snackyConfig.filterOpen == 1 && $oBox->position == 'left') || ($oBox->position == 'bottom' && $snackyConfig.footerBoxesOpen === '0')}<span class="caret"></span>{/if}
            </div>
        {/block}
        {block name='boxes-box-linkgroups-content'}
        <div class="panel-body">
            <ul class="nav blanklist">
                {block name='boxes-box-linkgroups-include-linkgroups-recursive'}
                    {include file='snippets/linkgroup_recursive.tpl' linkgroupIdentifier=$oBox->getLinkGroupTemplate() dropdownSupport=true  tplscope='box' limit=3}
                {/block}
            </ul>
        </div>
        {/block}
    </section>
{/block}
{/if}