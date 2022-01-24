{block name='snippets-language-dropdown'}
    {if isset($smarty.session.Sprachen) && $smarty.session.Sprachen|@count > 1}
        {if isset($isFooter) && $isFooter}
        <div class="dropdown mb-xxs">
        {else}
        <li class="dropdown">
        {/if}
            <a href="#" class="language-dropdown dpflex-a-c {$dropdownClass|default:''}{if isset($isFooter) && $isFooter} btn btn-primary btn-block btn-sm{/if}" data-toggle="dropdown" title="{lang key='selectLang'}">
                {foreach $smarty.session.Sprachen as $language}
                    {if $language->getId() == $smarty.session.kSprache}
                        {block name='snippets-language-dropdown-text'}
                            {$language->getIso639()|upper}
                        {/block}
                    {/if}
                {/foreach}
                <span class="caret"></span>
            </a>
            <ul class="dropdown-menu">
            {foreach $smarty.session.Sprachen as $language}
                {block name='snippets-language-dropdown-item'}
                    {if $language->getId() != $smarty.session.kSprache}
                    <li>
                        <a href="{$language->getUrl()}" class="link-lang"  data-iso="{$language->getIso()}" rel="nofollow">
                            {$language->getIso639()|upper}
                        </a>
                    </li>
                    {/if}
                {/block}
            {/foreach}
            </ul>
        {if isset($isFooter) && $isFooter}
        </div>
        {else}
        </li>
        {/if}
    {/if}
{/block}
