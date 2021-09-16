{block name='snippets-filter-genericFilterItem'}
    {block name='snippets-filter-genericFilterItem-nav'}
        <ul class="nav blanklist">
        {foreach $filter->getOptions() as $filterOption}
            {assign var=filterIsActive value=$filterOption->isActive() || $NaviFilter->getFilterValue($filter->getClassName()) === $filterOption->getValue()}
            {block name='snippets-filter-genericFilterItem-nav-main'}
            <li class="nav-it">
                <a class="filter-item dpflex-a-center{if $filterIsActive === true} active{/if}{if isset($itemClass)} {$itemClass}{/if}" href="{if $filterOption->isActive()}{$filter->getUnsetFilterURL($filterOption->getValue())}{else}{$filterOption->getURL()}{/if}" nofollow=true>
                    <span class="name{if $filter->getNiceName() === 'Rating'} dpflex-wrap{/if}">
                    {if $filter->getNiceName() === 'Rating'}
                        {block name='snippets-filter-genericFilterItem-include-rating-nav'}
                            {include file='productdetails/rating.tpl' stars=$filterOption->getValue()}
                        {/block}
                    {/if}
                    {$filterOption->getName()}
                    </span>
                    <span class="ctr">{$filterOption->getCount()}</span>
                </a>
            </li>
            {/block}
        {/foreach}
        </ul>
    {/block}
{/block}
