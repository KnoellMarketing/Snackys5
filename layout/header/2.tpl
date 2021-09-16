{block name="km-header-2"}
{block name="header-branding-content"}
	<header class="hidden-print" id="shop-nav">
		<div class="mw-container dpflex-a-center dpflex-wrap">
			<div class="col-4 visible-xs">
				{include file="snippets/mobilenav-toggle.tpl"}
				<div id="sr-tg-m" class="pr">
					<span class="img-ct icon">
						<svg class="{if $darkHead == 'true' || $darkMode == 'true'}icon-darkmode{/if}">
						  <use xlink:href="{$ShopURL}/{if empty($parentTemplateDir)}{$currentTemplateDir}{else}{$parentTemplateDir}{/if}img/icons/icons.svg#icon-search"></use>
						</svg>
					</span>
					<span class="close close-btn"></span>
				</div>
			</div>
			<div class="col-12 col-sm-4 hidden-xs">		
				{if $snackyConfig.headerSocial == 0}
					{include file="snippets/socialprofiles.tpl"}
				{/if}
			</div>
			<div class="col-12 col-sm-4 inside dpflex-a-center dpflex-j-center" id="search">
				{include file="snippets/header-search.tpl"}
			</div>
			<div class="col-4" id="logo" itemprop="publisher" itemscope itemtype="http://schema.org/Organization" itemid="">
				{include file='layout/shoplogo.tpl'}
			</div>
			{block name="header-branding-shop-nav"}
				<div class="col-4">
					{include file='layout/header_shop_nav.tpl'}
				</div>
			{/block}
		</div>
	</header>
{/block}

{if $nSeitenTyp !== 11}
	<div class="category-nav navbar-wrapper hidden-xs" id="cat-w">
		{include file="layout/header_category_nav.tpl"}
	</div>{* /category-nav *}
    <div class="overlay-bg" id="cls-catw"></div>
	{include file='layout/breadcrumb.tpl'}
{/if}
{/block}