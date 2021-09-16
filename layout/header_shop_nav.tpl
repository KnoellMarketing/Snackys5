{strip}
<div class="hdr-nav dpflex-a-center dpflex-j-end">
{if $snackyConfig.headerType == 1 || $snackyConfig.headerType == 2 || $snackyConfig.headerType == 3 || $snackyConfig.headerType == 4 || $snackyConfig.headerType == 5 || $snackyConfig.headerType == 6 || $snackyConfig.headerType == 4.5 || $snackyConfig.headerType == 5.5 || $snackyConfig.headerType == 7}
{block name="navbar-productsearch"}
	<div class="sr-tg hidden-xs">
		<span class="img-ct icon icon-xl">
			<svg class="{if $darkHead == 'true' || $darkMode == 'true'}icon-darkmode{/if}">
			  <use xlink:href="{$ShopURL}/{if empty($parentTemplateDir)}{$currentTemplateDir}{else}{$parentTemplateDir}{/if}img/icons/icons.svg#icon-search"></use>
			</svg>
		</span>
		<span class="img-ct icon icon-xl">
			<svg class="{if $darkHead == 'true' || $darkMode == 'true'}icon-darkmode{/if}">
			  <use xlink:href="{$ShopURL}/{if empty($parentTemplateDir)}{$currentTemplateDir}{else}{$parentTemplateDir}{/if}img/icons/icons.svg#icon-close"></use>
			</svg>
		</span>
	</div>
{/block}
{/if}
{block name="navbar-top-user"}
	
	{*  ACCOUNT *}
	<div class="dropdown">
		<a href="#" data-toggle="modal" data-target="#login-popup" {if empty($smarty.session.Kunde->kKunde)}title="{lang key='login'}"{else}title="{lang key='hello'}"{/if}>
			<span class="img-ct icon icon-xl">
				<svg class="{if $darkHead == 'true' || $darkMode == 'true'}icon-darkmode{/if}">
				  <use xlink:href="{$ShopURL}/{if empty($parentTemplateDir)}{$currentTemplateDir}{else}{$parentTemplateDir}{/if}img/icons/icons.svg#icon-user"></use>
				</svg>
			</span>
		</a>
		{include file='layout/header_shopnav_user.tpl'}
	</div>
	{*  ACCOUNT END *}

{*  COMPARE LIST *}
{include file='layout/header_shop_nav_compare.tpl'}
{*  COMPARE LIST *}

{*  WISH LIST *}
{include file='layout/header_shop_nav_wish.tpl'}
{*  WISH LIST *}

{*  CART *}
<div class="cart-menu dropdown{if $WarenkorbArtikelPositionenanzahl >= 1} items{/if}{if $nSeitenTyp == 3} current{/if}{if isset($bWarenkorbHinzugefuegt) && $bWarenkorbHinzugefuegt} open{/if}" data-toggle="basket-items">
    {include file='basket/cart_dropdown_label.tpl'}
</div>
{*  CART END *}
{/block}{* /navbar-top-user *}
</div>{* /shop-nav *}
{/strip}