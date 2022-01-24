{block name='basket-cart-dropdown-label'}
<a href="{get_static_route id='warenkorb.php'}" class="basket-opener" title="{lang key='basket'}">
    <span class="img-ct icon icon-xl">
		<svg class="{if $darkHead == 'true' || $darkMode == 'true'}icon-darkmode{/if}">
		  <use xlink:href="{$ShopURL}/{if empty($parentTemplateDir)}{if empty($currentTemplateDir)}templates/Snackys/{else}{$currentTemplateDir}{/if}{else}{$parentTemplateDir}{/if}img/icons/icons.svg?v={$nTemplateVersion}#icon-{if $snackyConfig.basketType == 0}cart{else}shopping{/if}"></use>
		</svg>
    </span>
    {if $WarenkorbArtikelPositionenanzahl >= 1}
    <sup class="badge"><em>{$WarenkorbArtikelPositionenanzahl}</em></sup>
    {/if}
</a>
<ul class="c-dp small dropdown-menu dropdown-menu-right{if $smarty.session.Warenkorb->PositionenArr|@count == 0} no-items{/if}">
    <li class="inside m0 w100">
        <div class="items-list cart-icon-dropdown nav-item">
            {include file='basket/cart_dropdown.tpl' isSidebar="1"}
			<div class="fixed-btn-group{if $snackyConfig.shopBButton == 1} one-button{/if}">
				<a href="{get_static_route id='warenkorb.php'}" class="btn btn-block{if $snackyConfig.shopBButton == 1} btn-primary btn-lg{/if}" title="{lang key='gotoBasket'}"> {lang key='gotoBasket'}</a>
				{if $snackyConfig.shopBButton == 0}
				<a href="{get_static_route id='bestellvorgang.php'}" class="btn btn-primary btn-block btn-lg">{lang key="checkout" section="basketpreview"}</a>
				{/if}
			</div>
            <div class="add-pays cart-dropdown-buttons">
                <div class="paypal"></div>
                <div class="amazon"></div>
            </div>
            <div class="payplan"></div>
            {getLink nLinkart=12 cAssign="linkdatenschutz"}
            {getLink nLinkart=27 cAssign="linkimpressum"}
            {if $linkimpressum || $linkdatenschutz}
            <div class="text-center small mt-xs">
                {if $linkdatenschutz}
                    <a href="{$linkdatenschutz->getURL()}" rel="nofollow">
                        {if !empty($linkdatenschutz->getTitle())}
                            {$linkdatenschutz->getTitle()}
                        {else}
                            {$linkdatenschutz->getName()}
                        {/if}
                    </a>
                {/if}
                {if $linkimpressum && $linkdatenschutz} • {/if}
                {if $linkimpressum}
                    <a href="{$linkimpressum->getURL()}" rel="nofollow">
                        {if !empty($linkimpressum->getTitle())}
                            {$linkimpressum->getTitle()}
                        {else}
                            {$linkimpressum->getName()}
                        {/if}
                    </a>
                {/if}
            </div>
            {/if}
        </div>
    </li>
    <li class="overlay-bg"></li>
    <li class="close-sidebar close-btn"></li>
</ul>
{/block}